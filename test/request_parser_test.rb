require "minitest/autorun"
require "./lib/request_parser"
require "minitest/pride"

########## 2 - PARSE RAW REQUEST LINES INTO REQUEST DATA (Hash OR Request object of some sort)
### VERB, PATH, PROTOCOL, HOST, HEADERS, BODY, PORT, ORIGIN
############################

class RequestParserTest < Minitest::Test
  def test_exists
    assert RequestParser
  end

  def test_pulling_key_and_value_from_single_header
    assert_equal(["Host", "127.0.0.1:9297"], RequestParser.new.parse_header_line("Host: 127.0.0.1:9297"))
  end

  def test_gets_verb_path_and_protocol_from_first_line
    assert_equal({"Verb" => "POST", "Path" => '/', "Protocol" => 'HTTP/1.1'}, RequestParser.new.parse_first_line("POST / HTTP/1.1") )
  end

  def test_parses_whole_request
    req = RequestParser.new(sample_request_lines)

    assert_equal "POST", req.verb
    assert_equal "/", req.path
    assert_equal "HTTP/1.1", req.protocol
    assert_equal ["Host", "Connection", "Content-Length", "Cache-Control", "Origin", "Accept"], req.headers.keys
  end

  def sample_request_lines
    ["POST / HTTP/1.1",
      "Host: 127.0.0.1:9297",
      "Connection: keep-alive",
      "Content-Length: 0",
      "Cache-Control: no-cache",
      "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
       "Accept: */*"]
  end
end
