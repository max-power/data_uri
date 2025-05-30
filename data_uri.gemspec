# frozen_string_literal: true

require_relative "lib/data_uri/version"

Gem::Specification.new do |spec|
  spec.name = "data_uri"
  spec.version = DataURI::VERSION
  spec.authors = ["Max Power"]
  spec.email = ["kevin.melchert@gmail.com"]

  spec.summary     = "Adds RFC 2397 'data:' URI support to Ruby's URI module."
  spec.description = "This gem extends Ruby's URI module with native support for data URIs (data:), allowing encoding, decoding, and parsing of inline data using media types, character sets, and optional base64 encoding."
  spec.homepage    = "https://github.com/max-power/data_uri"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

#  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
#  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "base64"
end
