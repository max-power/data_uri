# URI::Data

<!--[![Gem Version](https://badge.fury.io/rb/data_uri.svg)](https://rubygems.org/gems/data_uri)-->

`data_uri` extends Ruby’s built-in `URI` module with support for [`data:` URIs](https://datatracker.ietf.org/doc/html/rfc2397), allowing you to parse, build, and encode inline data resources easily.

---

## Features

- Full support for `data:` URIs per RFC 2397
- Automatic parsing of media type, charset, and parameters
- Base64 and URL-encoded data support
- Easy `build_from` helper for creating data URIs

---

## Installation

Add this line to your Gemfile:

```ruby
gem 'data_uri'
Or install it directly:

gem install data_uri
```

## Usage

### Parsing a data URI

```ruby
require 'uri'
require 'data_uri' # load the extension

uri = URI.parse("data:text/plain;charset=UTF-8,Hello%20world")

puts uri.class         # => URI::Data
puts uri.content_type  # => "text/plain"
puts uri.charset       # => "UTF-8"
puts uri.data          # => "Hello world"
```

### Building a data URI
```ruby
uri = URI::Data.build_from(
  data: "Hello μ",
  content_type: "text/plain",
  charset: "utf-8"
)

puts uri.to_s # => data:text/plain;charset=utf-8,Hello+%CE%BC
```
### Base64 Encoding
```ruby
uri = URI::Data.build_from(
  data: File.binread("image.png"),
  content_type: "image/png",
  base64: true
)

puts uri.to_s # => data:image/png;base64,...
```
## API Reference

### Instance Methods
- `#content_type` → media type (e.g., "image/png")
- `#charset` → declared charset, default: "US-ASCII"
- `#parameters` → parsed header parameters (as a Hash)
- `#data` → decoded data as a string or binary

### Class Methods

- `URI::Data.build(opaque)` → build from raw data URI string (excluding data:)
- `URI::Data.build_from(data:, content_type:, base64:, **params)` → build structured data: URI

## Development

To run tests:
```ruby
bundle install
bundle exec rake
```

MIT License. See LICENSE for details.

## Links

- [RFC 2397 – The "data:" URL scheme](https://datatracker.ietf.org/doc/html/rfc2397)
- [Ruby URI Module](https://ruby-doc.org/3.4.1/stdlibs/uri/URI.html)
