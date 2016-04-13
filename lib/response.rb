require './lib/request_parser.rb'

class Response
  attr_reader :requested_lines

  def initialize(requested_lines)
    @requested_lines = requested_lines
    @request = RequestParser.new(request_lines)
  end

  def parse_header_line(header)

  end

end
