require './lib/request_parser.rb'
require './lib/persist'

class Response
  attr_reader :ps

  def initialize(request, counter = nil, ps = nil)
    @ps = ps
  end

  def output(request, counter = nil, ps = nil)
    if action(request) == "/"
       get_diagnostics(request)
    elsif action(request) == "/hello"
       get_hello
    elsif action(request) == "/datetime"
       get_date
    elsif action(request) == "/shutdown"
       get_shutdown(counter)
    elsif action(request) == "/word_search"
      determine_valid_word(searched_variable(request))
    elsif action(request) == "/start_game"
      ps.game = true
      ps.code = rand(0..100)
      ps.guess_count = 0
      start_game
    elsif action(request) == "/game" && request.verb == "GET" && @ps.game == true
      give_game_info
    elsif action(request) == "/game" && request.verb == "POST" && @ps.game == true
      create_game_info(request)
    end
  end

  def content_length(request)
    if request.headers.include?("Content-Length") != false
      request.headers.fetch("Content-Length").to_i
    else
      "0".to_i
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
      "Origin: #{request.headers.fetch("Host")[0..-6]}",
      "Accept: #{request.headers.fetch("Accept")}",
      "Content-Length: #{content_length(request)}"
    ].join("\n")
  end


  def get_hello
    @ps.hello_count += 1
    "Hello World! #{@ps.hello_count}"
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

  def searched_variable(request)
    variable = request.path.split('?')[1]
    return "" if variable.nil?
    variable.split('=')[1]
  end

  def start_game
    "Good Luck!"
  end

  def give_game_info
    [
    "Guess Count: #{@ps.guess_count}",
    "Guess was: #{@ps.info}",
    conditional_info
  ]
  end

  def conditional_info
    if @ps.info == nil
      nil
    elsif @ps.info.to_i < @ps.code
      "Your guess was too low..."
    elsif @ps.info.to_i > @ps.code
      "Your guess was too high..."
    else @ps.info.to_i == @ps.code
      "Success!"
    end
  end

  def create_game_info(request)
    @ps.guess_count += 1
  end

end
