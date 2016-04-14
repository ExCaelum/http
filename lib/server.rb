require 'socket'
require 'pry'
require './lib/response'

class Server

  def initialize
    @tcp_server = TCPServer.new(9297)
  end

  def request
    counter = 0
    while true
      client = @tcp_server.accept
      request_lines = get_lines(client)
      counter += 1
      request = RequestParser.new(request_lines)
      response_params = {
        request: request,
        counter: counter
      }
      response = Response.new(response_params)
      client.puts response.output

      break if request.path == "/shutdown"
      client.close
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


  # def get_response
  #   # response = <pre> + response.output(request, client, counter) + </pre>
  #   # Body, Headers, Verb, Path, Protocol
  #   @output = "<html><head></head><body><pre>#{response}</pre></body></html>"
  #   @headers = ["http/1.1 200 ok",
  #             "date: #{Time.now.strftime('%a, %e %b %Y %H:%M%S %z')}",
  #             "server: ruby",
  #             "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
  #             "content-type: text/html; charset=iso-8859-1",
  #             "content-length: #th}\r\n\r\n#{@output}"].join("\r\n")
  # end
  #
  # def display_message(client)
  #   puts ["Wrote this response:", @headers, @output].join("\n")
  #   client.puts @headers
  #   client.puts @output
  # end
