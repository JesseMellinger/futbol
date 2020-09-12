require 'csv'
require './lib/game_team'

class GameTeamManager
  attr_reader :game_teams, :tracker

  def initialize(data, tracker)
    @game_teams = []
    @tracker = tracker
    create_game_teams(data)
  end

  def create_game_teams(data)
    @game_teams = data.map do |data|
      GameTeam.new(data, self)
    end
  end

  def winningest_coach(game_ids)
    season_games = find_season_by_game_ids(game_ids)
    coach_results = group_season_games_by_coach_results(season_games)
    coach_with_greatest_win_percentage(coach_results)
  end

  def find_season_by_game_ids(game_ids)
    @game_teams.find_all do |game|
      game_ids.include?(game.game_id)
    end
  end

  def group_season_games_by_coach_results(season_games)
    season_games.group_by do |game|
      game.head_coach
    end.transform_values! {|games| games.partition {|game| game.result == "WIN"}.map(&:length)}
  end

  def coach_with_greatest_win_percentage(coach_results)
    coach_results.max_by do |coach, games|
      games[0].to_f / games.sum
    end.first
  end

end
