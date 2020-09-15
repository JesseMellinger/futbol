require 'csv'
require_relative './game'

class GameManager
  attr_reader :games, :tracker

  def initialize(data, tracker)
    @games = []
    @tracker = tracker
    create_games(data)
  end

  def create_games(data)
    @games = data.map do |data|
      Game.new(data, self)
    end
  end

  def winningest_coach(season_id)
    @tracker.game_team_manager.winningest_coach(find_game_ids_of_season(season_id))
  end

  def worst_coach(season_id)
    @tracker.game_team_manager.worst_coach(find_game_ids_of_season(season_id))
  end

  def find_game_ids_of_season(season_id)
    @games.find_all do |game|
      game.season == season_id
    end.map {|game| game.game_id}
  end

  def find_games_by_team(team_id)
    @games.find_all do |game|
      game.away_team_id == team_id || game.home_team_id == team_id
    end
  end

  def highest_total_score
    scores = @games.map do |game|
      game.home_goals.to_i + game.away_goals.to_i
    end.max
  end

  def lowest_total_score
    scores = @games.map do |game|
      game.home_goals.to_i + game.away_goals.to_i
    end.sort![0]
  end

  def percentage_home_wins
    count = @games.count do |game|
      game.home_goals > game.away_goals
    end
    (count.to_f / @games.count).round(2)
  end

  def percentage_visitor_wins
    count = @games.count do |game|
      game.away_goals > game.home_goals
    end
    (count.to_f / @games.count).round(2)
  end

  def percentage_ties
    count = @games.count do |game|
      game.away_goals == game.home_goals
    end
    (count.to_f / @games.count).round(2)
  end

  def season_keys
    @games.map do |game|
      game.season
    end.uniq
  end

  def count_of_games_by_season
    games_per_season = Hash[self.season_keys.collect {|item| [item, 0]}]
    games_per_season.each do |season, games|
      @games.each do |game|
        if game.season.include?(season)
          games_per_season[season] += 1
        end
      end
    end
  end

  def average_goals_per_game
    count = @games.map do |game|
      game.away_goals.to_i + game.home_goals.to_i
    end
    (count.sum.to_f/ @games.length).round(2)
  end

  def total_goals_by_season
   hash = Hash[self.season_keys.collect {|item| [item, 0]}]
   hash.each do |season, games|
     @games.each do |game|
       if game.season.include?(season)
         hash[season] += game.away_goals.to_i + game.home_goals.to_i
       end
     end
   end
 end

 def average_goals_by_season
    goals_hash = Hash.new(0)
    total_goals_by_season.each do |season1, goals|
      count_of_games_by_season.each do |season2, games|
        if season2.include?(season1)
          goals_hash[season2] = (goals/ games.to_f).round(2)
        end
      end
    end
    goals_hash
  end

end
