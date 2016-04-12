require 'socket'
require 'pry'

class Server

  def initialize
    @tcp_server = TCPServer.new(9297)
    @counter = 0
  end

  def request
    while true
      client = @tcp_server.accept
      request_lines = []
      while line = client.gets and !line.chomp.empty?
        request_lines << line.chomp
      end
      puts request_lines.inspect
      @response = request_lines.join("\n")
      get_response
      @counter += 1
      display_message(client)
      client.close
    end
  end

  private

  def get_response
    # response = <pre> + response + </pre>
    # binding.pry
    @response = parse_response
    @output = "<html><head></head><body><pre>#{@response}</pre></body></html>"
    @headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M%S %z')}",
              "server: ruby",
              "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{@output.length}\r\n\r\n"].join("\r\n")
  end

  def parse_response
    string = " Verb: #{verb}
              Path: #{path}
              Protocol: #{protocol}
              Host: #{host}
              Port: #{port}
              Origin: #{host}"
              # Accept: #{accept}"
  end

  def verb
    @response.split("\n")[0].split(" ")[0]
  end

  def path
    @response.split("\n")[0].split(" ")[1]
  end

  def protocol
    @response.split("\n")[0].split(" ")[2]
  end

  def host
    @response.split("\n")[1].split(" ")[1].split(":")[0]
  end

  def port
    @response.split("\n")[1].split(" ")[1].split(":")[1]
  end

  # def accept
  #
  # end

  def display_message(client)
    puts ["Wrote this response:", @headers, @output].join("\n")
    client.puts @header
    client.puts @output
    client.puts "Hello World! (#{@counter})"
  end
end

s = Server.new
s.request



=begin

=> ["POST / HTTP/1.1",
 "Host: localhost:9295",
 "Connection: keep-alive",
 "Content-Length: 137",
 "Cache-Control: no-cache",
 "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
 "Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryoom54GNz8Tvrhlx2",
 "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.110 Safari/537.36",
 "Postman-Token: 71df0140-f0cc-ac86-1f8d-3d7d6e2475a8",
 "Accept: */*",
 "Accept-Encoding: gzip, deflate",
 "Accept-Language: en-US,en;q=0.8"]
[6] pry(#<Server>)> response.split("\n")[0].split(" ")[0]
=> "POST"
[7] pry(#<Server>)> response.split("\n")[0].split(" ")[1]
=> "/"
[8] pry(#<Server>)> response.split("\n")[0].split(" ")[2]
=> "HTTP/1.1"
[9] pry(#<Server>)> response.split("\n")[1].split(" ")[1]
=> "localhost:9295"
[10] pry(#<Server>)> response.split("\n")[1].split(" ")[1].split(":")[1]
=> "9295"
[11] pry(#<Server>)> response.split("\n")[5].split(" ")[1]
=> "chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop"
[12] pry(#<Server>)> response.split("\n")[9].split(" ")[1]
=> "*/*"
[13] pry(#<Server>)>

=end
