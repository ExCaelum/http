class RequestParser

  def initialize(request_lines = [])
    @request_lines = request_lines
  end

  def parse_header_line(header)
    header.split(": ")
  end

  def parse_first_line(first_line)
    parts = first_line.split
    verb = parts[0]
    path = parts[1]
    protocol = parts[2]
    {"Verb" => verb, "Path" => path, "Protocol" => protocol}
  end

  def verb
    parse_first_line(@request_lines.first)["Verb"]
  end

  def path
    parse_first_line(@request_lines.first)["Path"]
  end

  def protocol
    parse_first_line(@request_lines.first)["Protocol"]
  end

  def headers
    @request_lines.drop(1).map do |line|
      parse_header_line(line)
    end.to_h
  end
end
