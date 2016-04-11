require 'minitest/autorun'
require 'minitest/pride'
require './lib/server.rb'

class ServerTest < Minitest::Test
  def setup
    @s = Server.new
  end

  def test_request_lines_is_functional
    lines = "GET / HTTP/1.1\nHost: 127.0.0.1:9295\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/601.5.17 (KHTML, like Gecko) Version/9.1 Safari/601.5.17"
    assert_equal lines, @s.request
  end


end
