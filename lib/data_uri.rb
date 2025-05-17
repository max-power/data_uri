# frozen_string_literal: true

require_relative "data_uri/version"
require "uri"
require "base64"

module URI
  class Data < Generic
    COMPONENT = [:scheme, :opaque].freeze
    
    DEFAULT_CONTENT_TYPE = 'text/plain'
    DEFAULT_CHARSET      = 'US-ASCII'

    attr_reader :content_type, :charset, :data, :parameters
    
    def initialize(*args)
      super
      parse_opaque!
    end
  
    def self.build(opaque)
      super(scheme: 'data', opaque: opaque.to_s)
    end
    
    def self.build_from(data:, content_type: DEFAULT_CONTENT_TYPE, base64: false, **params)
      header  = build_header(content_type, params, base64: base64)
      encoded = encode_data(data, base64: base64)
      build("#{header},#{encoded}")
    end
        
    private

    def parse_opaque!
      header, encoded = opaque.split(',', 2)
      raise URI::InvalidURIError, 'Malformed data URI' unless encoded

      parse_header(header)
      decode_data(encoded)
    end
    
    def parse_header(header)
      type, *params, base64 = header.split(';')

      @content_type = type || DEFAULT_CONTENT_TYPE
      @parameters   = parse_parameters(params)
      @charset      = @parameters[:charset] || DEFAULT_CHARSET
      @base64       = base64 == "base64"
    end

    def parse_parameters(params)
      params.each_with_object({}) do |param, hash|
        key, value = param.split('=', 2)
        hash[key.downcase.to_sym] = value if key && value
      end
    end
    
    def decode_data(encoded)
      @data = self.class.decode_data(encoded, base64: @base64)
    end

    def self.decode_data(data, base64: false)
      base64 ? Base64.decode64(data) : URI.decode_www_form_component(data)
    end    

    def self.encode_data(data, base64: false)
      base64 ? Base64.strict_encode64(data) : URI.encode_www_form_component(data)
    end
    
    def self.build_header(content_type = nil, params = nil, base64: false)
      header = []
      header << content_type
      header << URI.encode_www_form(params) unless params.empty?
      header << "base64" if base64
      header.compact.join(';')
    end
  end
  
  register_scheme "DATA", Data
end