  class Game
    attr_accessor :file, :player, :code, :answer_array

    def initialize player_name
      @file = File.open '5desk.txt'
      @player = Player.new(player_name)
      @guesses = 12
      @board = Board.new
      secret_word
    end

    def secret_word
      list = @file.readlines
      @code = list.sample
      if @code.length < 5 || @code.length > 12
        @code = list.sample
      end
      @code = @code.chars
      @code = @code.delete_if do |char|
        char == "\r" || char == "\n"
      end
    end

    def tries
      puts "Please guess a letter."
      answer = gets.chomp
      if answer.length > 1
        puts "Please enter a single letter for your guess."
        tries
      end
      @code.each_with_index do |char, index|
        if char != answer && @code.include?(answer)
          next
        elsif char == answer
          @board.hits[index] = answer
          break
        elsif char != answer
          @board.misses.push(answer)
          @board.misses = @board.misses.uniq
        end
      end
    end

    def start
      while @guesses > 0
        tries
        @guesses-=1
      end
    end

  end

  class Board
    attr_accessor :misses, :hits

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
d.start

