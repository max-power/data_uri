# frozen_string_literal: true

class TestDataUri < TLDR
  def test_that_it_has_a_version_number
    refute_nil ::DataURI::VERSION
  end
  
  def test_data_uri_is_registered
    assert URI.scheme_list.key?("DATA")
    assert_equal URI::Data, URI.scheme_list["DATA"]
  end
  
  def test_parse_custom_uri
    uri = URI("data:application/vnd-xxx-query,select_vcount,fcol_from_fieldtable/local")
    assert_equal "application/vnd-xxx-query", uri.content_type
    assert_equal "select_vcount,fcol_from_fieldtable/local", uri.data
  end
    
  def test_base64_encoded_image_gif_uri
    base64 = "R0lGODlhAQABAIABAAAAAP///yH5BAEAAAEALAAAAAABAAEAQAICTAEAOw=="
    uri = URI.parse("data:image/gif;base64,#{base64}")

    assert_instance_of URI::Data, uri
    assert_equal 'image/gif', uri.content_type
    assert_equal Base64.decode64(base64), uri.data
  end

  def test_text_plain_data_uri
    uri = URI.parse("data:,A%20brief%20note")

    assert_instance_of URI::Data, uri
    assert_equal 'text/plain', uri.content_type
    assert_equal 'A brief note', uri.data
  end

  def test_text_html_data_uri_with_charset
      uri = URI.parse("data:text/html;charset=utf-8,%3C%21DOCTYPE%20html%3E%0D%0A%3Chtml%20lang%3D%22en%22%3E%0D%0A%3Chead%3E%3Ctitle%3EEmbedded%20Window%3C%2Ftitle%3E%3C%2Fhead%3E%0D%0A%3Cbody%3E%3Ch1%3E42%3C%2Fh1%3E%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A%0D%0A")

      expected = "<!DOCTYPE html>\r\n<html lang=\"en\">\r\n<head><title>Embedded Window</title></head>\r\n<body><h1>42</h1></body>\n</html>\n\r\n"

      assert_instance_of URI::Data, uri
      assert_equal 'text/html', uri.content_type
      assert_equal expected, uri.data
    end

    def test_big_data_binary_data_uri
      skip
      data = Array.new(1000) { rand(256) }.pack('c*')
      raw = "data:application/octet-stream;base64,#{Base64.encode64(data).chop}"

      assert_raises(URI::InvalidURIError) { URI.parse(raw) }

      uri = URI::Data.build(raw)
      assert_equal data, uri.data
    end

    def test_invalid_data_uri
      assert_raises(URI::InvalidURIError) { URI::Data.build("This is not a data URI") }
      assert_raises(URI::InvalidURIError) { URI::Data.build("data:Neither this") }
    end

    def test_build_from
      data = "GIF89a\001\000\001\000\200\000\000\377\377\377\000\000\000!\371\004\000\000\000\000\000,\000\000\000\000\001\000\001\000\000\002\002D\001\000;"
      uri = URI::Data.build_from(content_type: 'image/gif', data: data, base64: true)

      expected = 'data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw=='
      assert_equal expected, uri.to_s
    end

    def test_build_with_no_content_type
      uri = URI::Data.build_from(data: "foobar", content_type: nil)
      assert_equal 'data:,foobar', uri.to_s
    end
  
end
