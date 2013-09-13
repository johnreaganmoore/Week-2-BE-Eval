module Tennis
  class Game
    attr_accessor :player1, :player2

    def initialize
      @player1 = Player.new
      @player2 = Player.new

      @player1.opponent = @player2
      @player2.opponent = @player1
    end

    def wins_ball(player)

      player.record_won_ball!
    end

  end

  class Player
    attr_accessor :points, :opponent

    def initialize
      @points = 0
      @opponent = self.opponent

    end

    # Increments the score by 1.
    #
    # Returns the integer new score.
    def record_won_ball!
      @points += 1
    end

    # Returns the String score for the player.
    def score
      return 'love' if @points == 0
      return 'fifteen' if @points == 1
      return 'thirty' if @points == 2
      
      if @points == 3 
        if deuce?
          return 'deuce' 
        else
          return 'forty'
        end
      end

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
    
    private

    def deuce?
      @points == @opponent.points
    end

    def advantage?
      @points == @opponent.points + 1
    end

    def disadvantage?
      @points + 1 == @opponent.points
    end

    def won_game?
      @points > @opponent.points + 1
    end
  end
end