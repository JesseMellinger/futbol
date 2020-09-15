require 'csv'
require './lib/team'

class TeamManager
  attr_reader :teams, :tracker

  def initialize(data, tracker)
    @teams = []
    @tracker = tracker
    create_teams(data)
  end

  def create_teams(data)
    @teams = data.map do |data|
      Team.new(data, self)
    end
  end

  def count_of_teams
    @teams.count
  end

  def find_team(team_id)
    teams.find do |team|
      team.team_id == team_id
    end
  end

  def team_info(team_id)
    find_team(team_id).team_info
  end

  def best_season(team_id)
    find_team(team_id).best_season
  end

  def worst_season(team_id)
    find_team(team_id).worst_season
  end

  def average_win_percentage(team_id)
    find_team(team_id).average_win_percentage
  end

  def win_percentage(game_teams)
    tracker.game_team_manager.win_percentage(game_teams)
  end

  def most_accurate_team(season_id)
    @tracker.game_team_manager.most_accurate_team(@tracker.game_manager.find_game_ids_of_season(season_id))
  end

  def least_accurate_team(season_id)
    @tracker.game_team_manager.least_accurate_team(@tracker.game_manager.find_game_ids_of_season(season_id))
  end

  def most_goals_scored(team_id)
    find_team(team_id).most_goals_scored
  end

  def fewest_goals_scored(team_id)
    find_team(team_id).fewest_goals_scored
  end

  def favorite_opponent(team_id)
    find_team(team_id).favorite_opponent
  end

  def rival(team_id)
    find_team(team_id).rival
  end

  def most_tackles(season_id)
    @tracker.game_team_manager.most_tackles(@tracker.game_manager.find_game_ids_of_season(season_id))
  end
end
