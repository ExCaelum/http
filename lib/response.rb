require './lib/request_parser.rb'

class Response

  def initialize(params = {})
    request = params[:request]
    counter = params[:counter]
  end

  def output(request, counter = nil)

    if action(request) == "/"
       get_diagnostics(request)
    elsif action(request) == "/hello"
       get_hello(counter)
    elsif action(request) == "/datetime"
       get_date
    elsif action(request) == "/shutdown"
       get_shutdown(counter)
    elsif action(request) == "/word_search"
      determine_valid_word(searched_word(request))
    end
  end

  private

  def action(request)
    request.path.split("?")[0]
  end

  def get_diagnostics(request)
    [
      "Verb: #{request.verb}",
      "Path: #{request.path}",
      "Protocol: #{request.protocol}",
      "Host: #{request.headers.fetch("Host")[0..-6]}",
      "Port: #{request.headers.fetch("Host")[-4..-1]}",
      "Origin: #{request.headers.fetch("Origin")[0..-6]}",
      "Accept: #{request.headers.fetch("Accept")}",
      "Content-Length: #{request.headers.fetch("Content-Length")}"
    ].join("\n")
  end

  def get_hello(counter)
    "Hello World! #{counter}"
  end

  def get_date
    Time.now.strftime('%l:%M %p on %A, %B %e, %Y')
  end

  def get_shutdown(counter)
    "Total Request: #{counter}"
  end

  def valid_words
    return @valid_words unless @valid_words.nil?
    words = File.readlines("/usr/share/dict/words")
    @valid_words = words.map {|word| word.chomp}
  end

  def determine_valid_word(word)
    if valid_words.include?(word)
      "#{word.upcase} is a known word"
    else
      "#{word.upcase} is not a known word"
    end
  end

  def searched_word(request)
    word = request.path.split('?')[1]
    return "" if word.nil?
    word.split('=')[1]
  end
end
