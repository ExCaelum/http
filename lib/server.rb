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


      ########## 1 - READ RAW REQUEST LINES
      request_lines = []
      counter += 1
      while line = client.gets and !line.chomp.empty?
        request_lines << line.chomp
      end

      ########## 2 - PARSE RAW REQUEST LINES INTO REQUEST DATA (Hash OR Request object of some sort)
      ### VERB, PATH, PROTOCOL, HOST, HEADERS, BODY, PORT, ORIGIN

      request = RequestParser.new(request_lines)

      ########## 3 - Use REQUEST DATA TO GENERATE RESPONSE DATA
      response = Response.new
      client.puts response.output(request, client, counter)

      break if request.path == "/shutdown"
      client.close
    end
  end
end
      ##############


      ########## 4 - USE RESPONSE DATA TO Generate a response string

      ########### 5 - PUSH RESPONSE STRING DOWN THE SOCKET
    #   puts request_lines.inspect
    #   @response = request_lines.join("\n")
    #   get_response
    #   @counter += 1
    #   display_message(client)
    #   client.close
    # end

  # private

  # def get_response
  #   # response = <pre> + response + </pre>
  #   # binding.pry
  #   # Body, Headers, Verb, Path, Protocol
  #   @output = "<html><head></head><body><pre>#{diagnostic_info}</pre></body></html>"
  #   @headers = ["http/1.1 200 ok",
  #             "date: #{Time.now.strftime('%a, %e %b %Y %H:%M%S %z')}",
  #             "server: ruby",
  #             "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
  #             "content-type: text/html; charset=iso-8859-1",
  #             "content-length: #th}\r\n\r\n#{@output}"].join("\r\n")
  # end
  #
  # def diagnostic_info
  #   " Verb: #{verb}
  #     Path: #{path}
  #     Protocol: #{protocol}
  #     Host: #{host}
  #     Port: #{port}
  #     Origin: #{host}"
  #             # Accept: #{accept}"
  # end
  #
  # def verb
  #   @response.split("\n")[0].split(" ")[0]
  # end
  #
  # def path
  #   @response.split("\n")[0].split(" ")[1]
  # end
  #
  # def protocol
  #   @response.split("\n")[0].split(" ")[2]
  # end
  #
  # def host
  #   @response.split("\n")[1].split(" ")[1].split(":")[0]
  # end
  #
  # def port
  #   @response.split("\n")[1].split(" ")[1].split(":")[1]
  # end
  #
  # def accept
  #   @response.split("\n")[6].split
  # end
  #
  # def display_message(client)
  #   puts ["Wrote this response:", @headers, @output].join("\n")
  #   client.puts @headers
  #   client.puts @output
  #   client.puts "Hello World! (#{@counter})"
