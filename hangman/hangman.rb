require 'YAML'
  class Game
    attr_accessor :text, :player, :code, :answer_array, :saved_game
    def initialize(player_name)
      @text = File.open '5desk.txt'
      @player = Player.new(player_name)
      @guesses = 12
      @board = Board.new
      secret_word
    end

    def secret_word
      list = @text.readlines
      @code = list.sample.downcase
      while @code.length < 5 || @code.length > 12
        @code = list.sample
      end
      @code = @code.chars
      @code = @code.delete_if do |char|
        char == "\r" || char == "\n"
      end
      @board.hits = @code.map { |var| var = "_"  }
    end

    def tries
      puts "Do you want to make a guess or save your current progress?"
      answer = gets.downcase.chomp
      if answer == "guess"
        puts "Please guess a letter."
        answer = gets.chomp
        answer = answer.downcase.strip
        if answer.length > 1
          @guesses+=1
          puts "Please enter a single letter for your guess."
          tries
        end
        @code.each_with_index do |char, index|
          if char != answer && @code.include?(answer)
            next
          elsif char == answer
            @board.hits[index] = answer
          end
        end
        if @code.all? { |var| var != answer } == true
          if answer.length > 1
          else
            @board.misses.push(answer)
          end
            @board.misses = @board.misses.uniq
            @guesses-=1
        end
        if @code == @board.hits
          puts "You have won!\nYou managed to guess the code, the answer is: #{@code.join}."
          exit
        end
      elsif answer == "save"
        puts "What is the name of your file?"
        file = gets.chomp.downcase
        save(file)
      end
    end

    def start
      while @guesses > 0
        tries
        puts "Misses: #{@board.misses}"
        puts "Hits: #{@board.hits}"
        puts "Number of guesses left: #{@guesses}"
      end
      puts "The secret word was #{@code.join}!"
    end

    def save(game)
      @saved_game = YAML::dump(game)
    end

    def load
      puts YAML::load(@saved_game)
    end

    def qq
      quit
    end
  end

  class Board
    attr_accessor :misses, :hits

    def initialize
      @misses = []
      @hits = []
    end

    def stickman
    end
  end

  class Player
    attr_accessor :name

    def initialize name
      @name = name
    end
  end