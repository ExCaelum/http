class Persistent
  attr_accessor :hello_count, :game, :code,
                :guess_count, :guess, :info

  def initialize
    @hello_count = 0
    @game = false
    @guess_count = 0
    @code = nil
    @info = nil
  end
end
