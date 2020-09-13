require 'csv'
require './lib/game'

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

  def find_game_ids_of_season(season_id)
    @games.find_all do |game|
      game.season == season_id
    end.map {|game| game.game_id}
  end
end
