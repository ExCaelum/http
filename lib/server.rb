require 'socket'
require 'pry'

class Server

  def initialize
    @tcp_server = TCPServer.new(9295)
    @counter = 0
  end

  def request
    while true
      client = @tcp_server.accept
      request_lines = []
      while line = client.gets and !line.chomp.empty?
        request_lines << line.chomp
      end
      get_response(request_lines.join("\n"))
      @counter += 1
      display_message(client)
      client.close
    end
  end

  private

  def get_response(response)
    response = "<pre>" + response + "</pre>"
    @output = "<html><head></head><body>#{response}</body></html>"
    @headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{@output.length}\r\n\r\n"].join("\r\n")
  end

  def display_message(client)
    puts ["Wrote this response:", @headers, @output].join("\n")
    client.puts @header
    client.puts @output
    client.puts "Hello World! (#{@counter})"
  end
end

s = Server.new
s.request
