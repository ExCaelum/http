require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/response.rb'

class ResponseTest < Minitest::Test
  def setup
    @req = RequestParser.new(sample_request_lines)
    @response = Response.new(@req.request_lines)
  end

  def test_it_has_request_parser_information
    skip
    assert_equal sample_request_lines, @response.requested_lines
  end

  def test_host_is_correct
    skip
    assert_equal (["Host", "127.0.0.1:9297"]), @response.parse_header_line("Host: 127.0.0.1:9297")
  end

  def sample_request_lines
    skip
    ["POST / HTTP/1.1",
      "Host: 127.0.0.1:9297",
      "Connection: keep-alive",
      "Content-Length: 0",
      "Cache-Control: no-cache",
      "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
       "Accept: */*"]
  end
end
