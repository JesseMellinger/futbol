require 'csv'
require_relative './game_team'
require_relative './groupable'
require_relative './findable'

class GameTeamManager
  include Groupable
  include Findable
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
    @tracker.team_manager.team_info(team_id)["team_name"]
  end

  def worst_offense
    team_id = group_by(@game_teams, :team_id, :goals).min_by do |team_id, goals_in_game|
      goals_in_game.map(&:to_i).sum.to_f / (goals_in_game.length)
    end.first
    @tracker.team_manager.team_info(team_id)["team_name"]
  end

  def highest_scoring_visitor
    away_games = find_all_home_or_away_games(@game_teams, "away")
    team_id = group_by(away_games, :team_id, :goals).max_by do |team_id, goals_in_game|
      goals_in_game.map(&:to_i).sum.to_f / (goals_in_game.length)
    end.first
    @tracker.team_manager.team_info(team_id)["team_name"]
  end

  def highest_scoring_home_team
    home_games = find_all_home_or_away_games(@game_teams, "home")
    team_id = group_by(home_games, :team_id, :goals).max_by do |team_id, goals_in_game|
      goals_in_game.map(&:to_i).sum.to_f / (goals_in_game.length)
    end.first
    @tracker.team_manager.team_info(team_id)["team_name"]
  end

  def lowest_scoring_visitor
    away_games = find_all_home_or_away_games(@game_teams, "away")
    team_id = group_by(away_games, :team_id, :goals).min_by do |team_id, goals_in_game|
      goals_in_game.map(&:to_i).sum.to_f / (goals_in_game.length)
    end.first
    @tracker.team_manager.team_info(team_id)["team_name"]
  end

  def lowest_scoring_home_team
    home_games = find_all_home_or_away_games(@game_teams, "home")
    team_id = group_by(home_games, :team_id, :goals).min_by do |team_id, goals_in_game|
      goals_in_game.map(&:to_i).sum.to_f / (goals_in_game.length)
    end.first
    @tracker.team_manager.team_info(team_id)["team_name"]
  end

  def winningest_coach(game_ids)
    season_games = find_season_by_game_ids(game_ids)
    coach_results = group_season_games_by_coach_results(season_games)
    coach_with_greatest_win_percentage(coach_results)
  end

  def worst_coach(game_ids)
    season_games = find_season_by_game_ids(game_ids)
    coach_results = group_season_games_by_coach_results(season_games)
    coach_with_worst_win_percentage(coach_results)
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

  def coach_with_worst_win_percentage(coach_results)
    coach_results.min_by do |coach, games|
      games[0].to_f / games.sum
    end.first
  end

  def win_percentage(game_teams)
    wins = game_teams.count do |game|
      game.result == "WIN"
    end
    (wins / game_teams.count.to_f).round(2)
  end

  def most_accurate_team(game_ids)
    season_games = find_season_by_game_ids(game_ids)
    total_shots = group_by(season_games, :team_id, :shots)
    total_goals = group_by(season_games, :team_id, :goals)

    shots_to_goals_ratio = find_shots_to_goal_ratio(total_goals, total_shots)
    team_id_with_highest_ratio = get_most_or_least_accurate_team_id(shots_to_goals_ratio).first
    @tracker.team_manager.team_info(team_id_with_highest_ratio)["team_name"]
  end

  def least_accurate_team(game_ids)
    season_games = find_season_by_game_ids(game_ids)
    total_shots = group_by(season_games, :team_id, :shots)
    total_goals = group_by(season_games, :team_id, :goals)

    shots_to_goals_ratio = find_shots_to_goal_ratio(total_goals, total_shots)
    team_id_with_lowest_ratio = get_most_or_least_accurate_team_id(shots_to_goals_ratio).last
    @tracker.team_manager.team_info(team_id_with_lowest_ratio)["team_name"]
  end

  def find_shots_to_goal_ratio(total_goals, total_shots)
    shots_to_goal_ratio = total_goals.merge!(total_shots) {|key, value1, value2|
    (value1.map(&:to_f).sum / value2.map(&:to_f).sum).round(6)}
  end

  def get_most_or_least_accurate_team_id(shots_to_goals_ratio)
    max_and_min_ratios = shots_to_goals_ratio.values.minmax
    [shots_to_goals_ratio.key(max_and_min_ratios.last), shots_to_goals_ratio.key(max_and_min_ratios.first)]
  end

  def opponent(game_team)
    game_teams.find do |game|
      game_team.game_id == game.game_id && game.team_id != game_team.team_id
      end
    end

  def most_tackles(game_ids)
    season_games = find_season_by_game_ids(game_ids)
    total_tackles_by_team = total_tackles(season_games)
    team_id_with_most_tackles = team_id_most_or_fewest_tackles(total_tackles_by_team).first
    @tracker.team_manager.team_info(team_id_with_most_tackles)["team_name"]
  end

  def total_tackles(season_games)
    total_tackles_by_team = {}
      season_games.each do |game|
      if total_tackles_by_team[game.team_id]
        total_tackles_by_team[game.team_id] += (game.tackles).to_i
      else
        total_tackles_by_team[game.team_id] = (game.tackles).to_i
      end
    end
    total_tackles_by_team
  end

  def team_id_most_or_fewest_tackles(total_tackles_by_team)
    max_and_min_ratios = total_tackles_by_team.values.minmax
    [total_tackles_by_team.key(max_and_min_ratios.last), total_tackles_by_team.key(max_and_min_ratios.first)]
  end

  def fewest_tackles(game_ids)
    season_games = find_season_by_game_ids(game_ids)
    total_tackles_by_team = total_tackles(season_games)
    team_id_with_fewest_tackles = team_id_most_or_fewest_tackles(total_tackles_by_team).last
    @tracker.team_manager.team_info(team_id_with_fewest_tackles)["team_name"]
  end
end
