class Game
  attr_accessor :file, :player

  def initialize player_name
    @file = File.open '5desk.txt'
    @player = Player.new(player_name)
    @guesses = 12
    @code = ''
  end

  def secret_word
    list = @file.readlines
    @code = list.sample
    if @code.length < 5 || @code.length > 12
      @code = list.sample
    end
  end

  def start
    while @guesses > 0
        answer = gets.chomp
      @gueses-=1
    end
  end

end

class Board
  def initialize
    @misses = []
    @hits = []
  end
end

class Player
  attr_accessor :name

  def initialize name
    @name = name
  end
end

d = Game.new("Shing")
d.secret_word

