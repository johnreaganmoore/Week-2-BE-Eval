require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'pry'
require_relative '../tennis'

describe Tennis::Game do
  let(:john) { Tennis::Player.new('john')}
  let(:emma) { Tennis::Player.new('emma')}
  let(:game) { Tennis::Game.new(john, emma, "game1") }

  describe '.initialize' do
    it 'creates two players' do
      expect(game.player1).to be_a(Tennis::Player)
      expect(game.player2).to be_a(Tennis::Player)
    end

    it 'sets the opponent for each player' do
      expect(game.player1.opponent).to eq(game.player2)
      expect(game.player2.opponent).to eq(game.player1)
    end
  end

  describe '#wins_ball' do
    context 'but has not yet won the game' do
      it 'increments the points of the winning player' do
        game.wins_ball(game.player1)

        expect(game.player1.points).to eq(1)
      end
    end

    context 'and wins the game' do
      it 'increments the points of the winning player and adds game to players @games array' do
        game.player1.points = 2
        game.wins_ball(game.player1)

        expect(game.player1.points).to eq(3)
        expect(game.player1.games.length).to eq(1)
      end
    end
  end

  describe '#wins_game' do
    it 'adds the game to the @games array of the winning player' do
      game.wins_game(game.player1)

      expect(game.player1.games.length).to eq(1)
    end

    context 'this is not the last game of the set' do
      it 'starts a new game with the same players' do
        game.set_total_games(0)
        game.wins_game(game.player1)

        expect(game.total_games).to eq(1)
      end
    end

    context 'this is the last game of the set' do
      context 'and not the last set of the match' do
        it 'starts a new game and new set with the same players and increments the players set count.' do
          game.player1.games_count = 3
          game.wins_game(game.player1)

          expect(game.player1.sets).to eq(1)
          expect(game.player1.games_count).to eq(0)
        end
      end

      context 'and the last set of the match' do
        it 'increments the match count of the winning player' 
          game.player1.sets = 3
          game.wins_game(game.player1)

          expect(game.player1.sets).to eq(0)
          expect(game.player1.games_count).to eq(0)
          expect(game.player1.matches).to eq(1)      
      end
    end
  end

  describe '#wins_match' do
    it 'increments the @match count of the player' do
      game.wins_match(game.player1)

      expect(game.player1.matches).to eq(1)
    end
  end
end

describe Tennis::Player do
  let(:player) do
    player = Tennis::Player.new('john')
    player.opponent = Tennis::Player.new('emma')

    return player
  end

  describe '.initialize' do
    it 'sets the points to 0' do
      expect(player.points).to eq(0)
    end 
  end

  describe '#record_won_ball!' do
    it 'increments the points' do
      player.record_won_ball!

      expect(player.points).to eq(1)
    end
  end

  describe '#record_won_set!' do
    it 'increments the points' do
      player.record_won_set!

      expect(player.sets).to eq(1)
    end
  end

  describe '#score' do
    context 'when points is 0' do
      it 'returns love' do
        expect(player.score).to eq('love')
      end
    end
    
    context 'when points is 1' do
      it 'returns fifteen' do
        player.points = 1

        expect(player.score).to eq('fifteen')
      end 
    end
    
    context 'when points is 2' do
      it 'returns thirty'  do
        player.points = 2

        expect(player.score).to eq('thirty')
      end
    end
    
    context 'when points is 3' do

      context 'and opponent points == 3' do
        it 'returns deuce' do
          player.points = 3
          player.opponent.points = 3

          expect(player.score).to eq('deuce')
        end
      end

      context 'and opponent points < 3' do
        it 'returns forty' do
          player.points = 3
          player.opponent.points = 2

          expect(player.score).to eq('forty')
        end
      end

    end

    context 'when points > 3' do
      
      context 'and player.points == opponent.points' do
        it 'returns deuce' do
          player.points = 4
          player.opponent.points = 4

          expect(player.score).to eq('deuce')
        end
      end

      context 'and player.points == opponent.points + 1' do
        it 'returns advantage' do
          player.points = 5
          player.opponent.points = 4

          expect(player.score).to eq('advantage')
        end
      end

      context 'and player.points + 1 == opponent.points' do
        it 'returns disadvantage' do
          player.points = 4
          player.opponent.points = 5

          expect(player.score).to eq('disadvantage')
        end
      end

      context 'and player.points > opponent.points + 1' do
        it 'returns won game' do
          player.points = 6
          player.opponent.points = 4

          expect(player.score).to eq('won game')
        end
      end

      context 'and player.points + 1 < opponent.points' do
        it 'returns lost game' do
          player.points = 4
          player.opponent.points = 6

          expect(player.score).to eq('lost game')
        end
      end
    end
  end
end