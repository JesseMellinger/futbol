require 'csv'
require './lib/game_team'
require './lib/groupable'

class GameTeamManager
  include Groupable
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

  def best_offense
    team_id = group_by(@game_teams, :team_id, :goals).max_by do |team_id, goals_in_game|
      goals_in_game.map(&:to_i).sum.to_f / (goals_in_game.length)
    end.first
    @tracker.team_manager.teams.find {|team| team.team_id == team_id}.team_name
  end

  def worst_offense
    team_id = group_by(@game_teams, :team_id, :goals).min_by do |team_id, goals_in_game|
      goals_in_game.map(&:to_i).sum.to_f / (goals_in_game.length)
    end.first
    @tracker.team_manager.teams.find {|team| team.team_id == team_id}.team_name
  end

  def highest_scoring_visitor
    away_games = find_all_home_or_away_games("away")
    team_id = group_by(away_games, :team_id, :goals).max_by do |team_id, goals_in_game|
      goals_in_game.map(&:to_i).sum.to_f / (goals_in_game.length)
    end.first
    @tracker.team_manager.teams.find {|team| team.team_id == team_id}.team_name
  end

  def find_all_home_or_away_games(hoa)
    @game_teams.find_all do |game_team|
      game_team.hoa == hoa
    end
  end

  def find_games_by_team(team_id)
    @game_teams.find_all do |game_team|
      game_team.team_id == team_id
    end
  end

end
