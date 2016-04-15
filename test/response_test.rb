require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'pry'
require 'minitest/pride'
require './lib/response.rb'
require './lib/persist'

class ResponseTest < Minitest::Test

  def test_debug_if_path_is_slash
    sample_lines = ["GET / HTTP/1.1",
      "Host: 127.0.0.1:9297",
      "Connection: keep-alive",
      "Content-Length: 0",
      "Cache-Control: no-cache",
      "Origin: 127.0.0.1",
       "Accept: */*"]
    request = RequestParser.new(sample_lines)
    response = Response.new(request)
    string = "Verb: #{request.verb}\nPath: #{request.path}\nProtocol: #{request.protocol}\nHost: #{request.headers.fetch("Host")[0..-6]}\nPort: #{request.headers.fetch("Host")[-4..-1]}\nOrigin: #{request.headers.fetch("Host")[0..-6]}\nAccept: #{request.headers.fetch("Accept")}\nContent-Length: #{request.headers.fetch("Content-Length")}"
    assert_equal string, response.output(request)
  end

  def test_hello_world_if_path_is_hello
    counter = 1
    @ps = Persistent.new
    sample_lines = ["GET /hello HTTP/1.1",
      "Host: 127.0.0.1:9297",
      "Connection: keep-alive",
      "Content-Length: 0",
      "Cache-Control: no-cache",
      "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
       "Accept: */*"]
     request = RequestParser.new(sample_lines)
     response = Response.new(request, counter, @ps)
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
    response = Response.new(request)
    string = "#{date}"
    assert_equal string, response.output(request)
  end

 def test_total_request_if_path_is_shutdown
   counter = 1
   sample_lines = ["GET /shutdown HTTP/1.1",
     "Host: 127.0.0.1:9297",
     "Connection: keep-alive",
     "Content-Length: 0",
     "Cache-Control: no-cache",
     "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
      "Accept: */*"]
    request = RequestParser.new(sample_lines)
    response = Response.new(request, counter)
    string = "Total Request: #{counter}"
    assert_equal string, response.output(request, counter)
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
   response = Response.new(request)
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
   response = Response.new(request)
   string = "#{word.upcase} is not a known word"
   assert_equal string, response.output(request)
  end

  def test_goodluck_if_path_is_start_game
    @ps = Persistent.new
    counter = 0
    sample_lines = ["GET /start_game HTTP/1.1",
      "Host: 127.0.0.1:9297",
      "Connection: keep-alive",
      "Content-Length: 0",
      "Cache-Control: no-cache",
      "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
       "Accept: */*"]
    request = RequestParser.new(sample_lines)
    response = Response.new(request, counter, @ps)
    string = "Good Luck!"
    assert_equal string, response.output(request, counter, @ps)
    assert_equal true, @ps.game
  end

  def test_guess_count_increases_if_path_is_game_and_verb_is_post
    @ps = Persistent.new
    @ps.game = true
    counter = 0
    sample_lines = ["POST /game HTTP/1.1",
      "Host: 127.0.0.1:9297",
      "Connection: keep-alive",
      "Content-Length: 0",
      "Cache-Control: no-cache",
      "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
       "Accept: */*"]
    request = RequestParser.new(sample_lines)
    response = Response.new(request, counter, @ps)
    response.output(request, counter, @ps)
    assert_equal 1, @ps.guess_count
  end

  def test_have_game_info_for_path_of_game_with_verb_get
    @ps = Persistent.new
    @ps.game = true
    counter = 0
    sample_lines = ["GET /game HTTP/1.1",
      "Host: 127.0.0.1:9297",
      "Connection: keep-alive",
      "Content-Length: 0",
      "Cache-Control: no-cache",
      "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
       "Accept: */*"]
    request = RequestParser.new(sample_lines)
    response = Response.new(request, counter, @ps)
    string = ["Guess Count: 0", "Guess was: ", nil]
    assert_equal string, response.output(request, counter, @ps)
  end
end
