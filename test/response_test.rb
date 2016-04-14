require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/response.rb'

class ResponseTest < Minitest::Test

  def test_debug_if_path_is_slash
    sample_lines = ["GET / HTTP/1.1",
      "Host: 127.0.0.1:9297",
      "Connection: keep-alive",
      "Content-Length: 0",
      "Cache-Control: no-cache",
      "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
       "Accept: */*"]
    request = RequestParser.new(sample_lines)
    response = Response.new
    string = "Verb: #{request.verb}\nPath: #{request.path}\nProtocol: #{request.protocol}\nHost: #{request.headers.fetch("Host")[0..-6]}\nPort: #{request.headers.fetch("Host")[-4..-1]}\nOrigin: #{request.headers.fetch("Host")[0..-6]}\nAccept: #{request.headers.fetch("Accept")}"
    assert_equal string, response.output(request)
  end

  def test_hello_world_if_path_is_hello
    counter = 0
    sample_lines = ["GET /hello HTTP/1.1",
      "Host: 127.0.0.1:9297",
      "Connection: keep-alive",
      "Content-Length: 0",
      "Cache-Control: no-cache",
      "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
       "Accept: */*"]
     request = RequestParser.new(sample_lines)
     response = Response.new
     string = "Hello World! #{counter}"
     assert_equal string, response.output(request)
   end

 def test_time_if_path_is_datetime
   date = Time.now.strftime('%l:%M %p on %A, %B %e, %Y')
   sample_lines = ["GET /datetime HTTP/1.1",
     "Host: 127.0.0.1:9297",
     "Connection: keep-alive",
     "Content-Length: 0",
     "Cache-Control: no-cache",
     "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
      "Accept: */*"]
    request = RequestParser.new(sample_lines)
    response = Response.new
    string = "#{date}"
    assert_equal string, response.output(request)
  end

 def test_total_request_if_path_is_shutdown
   counter = 0
   sample_lines = ["GET /shutdown HTTP/1.1",
     "Host: 127.0.0.1:9297",
     "Connection: keep-alive",
     "Content-Length: 0",
     "Cache-Control: no-cache",
     "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
      "Accept: */*"]
    request = RequestParser.new(sample_lines)
    response = Response.new
    string = "Total Request: #{counter}"
    assert_equal string, response.output(request)
  end

  def test_word_response_if_word_search_is_path
    sample_lines = ["GET /word_search?word=hello HTTP/1.1",
      "Host: 127.0.0.1:9297",
      "Connection: keep-alive",
      "Content-Length: 0",
      "Cache-Control: no-cache",
      "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
       "Accept: */*"]
   request = RequestParser.new(sample_lines)
   word = request.path.split('?')[1].split('=')[1]
   response = Response.new
   string = "#{word.upcase} is a known word"
   assert_equal string, response.output(request)
  end

  def test_invalid_word_if_word_seach_is_path
    sample_lines = ["GET /word_search?word=alot HTTP/1.1",
      "Host: 127.0.0.1:9297",
      "Connection: keep-alive",
      "Content-Length: 0",
      "Cache-Control: no-cache",
      "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
       "Accept: */*"]
   request = RequestParser.new(sample_lines)
   word = request.path.split('?')[1].split('=')[1]
   response = Response.new
   string = "#{word.upcase} is not a known word"
   assert_equal string, response.output(request)
  end

  def sample_request_lines
    ["GET / HTTP/1.1",
      "Host: 127.0.0.1:9297",
      "Connection: keep-alive",
      "Content-Length: 0",
      "Cache-Control: no-cache",
      "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
       "Accept: */*"]
  end
end
