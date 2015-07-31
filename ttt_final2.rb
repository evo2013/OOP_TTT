require 'pry'

class Bot
  attr_accessor :name, :marker

  def initialize(name, marker)
    @name = name
    @marker = marker
  end
end

class Player
  attr_accessor :name, :marker

  def initialize (name, marker)
    @name = get_avatar
    @marker = marker
  end

  def get_avatar
    puts "What is your name?"
    avatar = gets.chomp.capitalize
  end
end

class Board
  attr_accessor :squares

  def initialize
    @squares = {}
    (1..9).each {|position| @squares[position] = " "}
  end

  def display_numbers
    puts
    puts " 1 | 2 | 3 "
    puts "-----------"
    puts " 4 | 5 | 6 "
    puts "-----------"
    puts " 7 | 8 | 9 "
    puts 
  end

  def display_game
    puts 
    puts " #{@squares[1]} | #{@squares[2]} | #{@squares[3]}"
    puts "-----------"
    puts " #{@squares[4]} | #{@squares[5]} | #{@squares[6]}"
    puts "-----------"
    puts " #{@squares[7]} | #{@squares[8]} | #{@squares[9]}" 
    puts
  end

  def get_empty_positions
    @squares.select {|keys| @squares[keys] == " "}.keys
  end

  def get_filled_positions
    @squares.select { |k, v| %w[X O].include? v }.keys
  end

  def all_filled_positions?
    get_empty_positions == []
  end

  def place_marker(position, marker)
    @squares[position] = marker
  end
end

class Game
  attr_accessor :board

  def welcome
    puts "
***********************************************************
          Welcome to the CLI Tic-Tac-Toe Game!
             Your opponent today is RubyBot.
                  Let's Get Started...
***********************************************************  "
    puts
    @board = Board.new
    @ruby_bot = Bot.new("RubyBot", "O")
    @player = Player.new("Human", "X")
    @current_player = @player
  end
 
  def mark_square
    if @current_player == @player
      begin
        puts " #{@player.name}, choose an unoccupied number position between 1 - 9 to mark with your 'X'."
        position = gets.chomp.to_i
        puts "\n Invalid option.\n" if !@board.get_empty_positions.include?(position)
      end until @board.get_empty_positions.include?(position)
    else 
      puts "\nRubyBot is taking a turn now...\n"
      sleep 2
      position =  @board.get_empty_positions.sample
    end
    @board.place_marker(position, @current_player.marker )
    @board.display_game
  end

  def alternate
    if @current_player == @player
       @current_player = @ruby_bot
    else
      @current_player = @player
    end
  end

  def win_check
    win_trio = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]] 
    win_trio.each do |trio|
      return "Player" if  @board.squares.select { |square, _| trio.include?(square) }.values.count('X') == 3
      return "RubyBot" if @board.squares.select { |square, _| trio.include?(square) }.values.count('O') == 3
    end
    nil
  end

  def run
    welcome
    @board.display_numbers
    begin
      mark_square
      winner = win_check
      filled = @board.all_filled_positions?
      alternate
    end until winner || filled
      if winner == "Player"
        puts "\nCongratulations #{@player.name} - You won this round!\n"
        exit
      elsif winner == "RubyBot"
        puts "\nRubyBot won this round!\n"
        exit
      else 
        puts "\nIt's a tie! No one won this round!\n"
        exit
      end
    end
end

game = Game.new
game.run
