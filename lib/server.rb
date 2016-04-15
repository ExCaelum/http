require 'socket'
require 'pry'
require './lib/response'
require './lib/persist'

class Server

  def initialize
    @ps = Persistent.new
    @tcp_server = TCPServer.new(9297)
  end

  def request
    counter = 0
    while true
      client = @tcp_server.accept
      request_lines = get_lines(client)
      counter += 1
      request = RequestParser.new(request_lines)
      response = Response.new(request, counter, @ps)
      output = response.output(request, counter, @ps)
      headers = ["HTTP/1.1 302 Found",
            "Location: http://127.0.0.1:9297/game\r\n\r\n"].join("\r\n")
      @ps.info = client.read(response.content_length(request))
      client.puts headers if request.verb == "POST" && @ps.game == true && request.path == "/game"
      client.puts output
      client.close
      break if request.path == "/shutdown"
    end
  end

  private

  def get_lines(client)
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end
end
