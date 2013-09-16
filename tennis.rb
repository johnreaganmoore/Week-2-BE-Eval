module Tennis
  
  class Match

  end

  class Set

  end

  class Game
    #Class Variables
    @@total_games = 0


    attr_accessor :player1, :player2

    def initialize(player1, player2, name)
      @player1 = player1
      @player2 = player2

      @player1.opponent = @player2
      @player2.opponent = @player1

      @name = name
      
    end

    def total_games
      @@total_games
    end

    def set_total_games(input)
      @@total_games = input
    end

    def wins_ball(player)
      player.record_won_ball!
      if player.won_game?
        wins_game(player)
      end
    end

    def wins_game(player)
      player.games << self
      player.games_count += 1
      if won_match?(player)
        player.record_won_set!
        player.record_won_match!   
      elsif won_set?(player)
        player.record_won_set!
        new_game
      else
        new_game
      end
    end

    def new_game
      @@total_games += 1
      Game.new(@player1, @player2, "game#{@@total_games}")
    end

    def won_set?(player)
      player.games_count >= 3
    end

    def won_match?(player)
      player.sets > 2
    end

  end

  class Player
    attr_accessor :points, :opponent, :games, :sets, :matches, :games_count

    def initialize(name)
      @name = name
      @points = 0     #counts the number of points the player has won in a game
      @games = []     #An array of games
      @games_count = 0
      @sets = 0       #Counts the number of sets a player has won
      @matches = 0      #Count of the matches the player has won
      @opponent = self.opponent

    end

    # Increments the score by 1.
    #
    # Returns the integer new score.
    def record_won_ball!
      @points += 1
    end

    def record_won_set!
      @sets += 1
      @games_count = 0
    end

    def record_won_match!
      @matches += 1
      @sets = 0
    end

    # Returns the String score for the player.
    def score
      #When the player doesn't have enough points to win the game
      return 'love' if @points == 0
      return 'fifteen' if @points == 1
      return 'thirty' if @points == 2
      
      #When the player has exactly enough points to potentially end the game
      if @points == 3 
        if deuce?
          return 'deuce' 
        else
          return 'forty'
        end
      end

      #When player has more than enough point to end a game deuce/advantage 
      if @points > 3
        if deuce?
          'deuce'
        elsif advantage?
          'advantage'
        elsif disadvantage?
          'disadvantage'
        elsif won_game?
          'won game'  
        else
          'lost game'
        end
      end        
    end

    #determines if the player has won the game
    def won_game?
      @points > @opponent.points + 1 && @points >= 3
    end
    
    private

    #determines if the score is deuce
    def deuce?
      @points == @opponent.points
    end

    #determines the player has advantage
    def advantage?
      @points == @opponent.points + 1
    end

    #determines if the players opponent has advantage
    def disadvantage?
      @points + 1 == @opponent.points
    end

  end
end