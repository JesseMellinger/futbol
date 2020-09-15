require 'csv'
require './lib/team_manager'
require './lib/game_manager'
require './lib/game_teams_manager'

class StatTracker
  attr_reader :team_manager, :game_manager, :game_team_manager

  def self.from_csv(locations)
    StatTracker.new(locations)
  end

  def initialize(locations)
    load_manager(locations)
  end

  def load_manager(locations)
    @team_manager = TeamManager.new(load_csv(locations[:teams]), self)
    @game_manager = GameManager.new(load_csv(locations[:games]), self)
    @game_team_manager = GameTeamManager.new(load_csv(locations[:game_teams]), self)
  end

  def load_csv(path)
    CSV.parse(File.read(path), headers: true, header_converters: :symbol)
  end

# ************* GameStatistics *************

  def highest_total_score
    @game_manager.highest_total_score
  end

  def lowest_total_score
    @game_manager.lowest_total_score
  end

  def percentage_home_wins
    @game_manager.percentage_home_wins
  end

  def percentage_visitor_wins
    @game_manager.percentage_visitor_wins
  end

  def percentage_ties
    @game_manager.percentage_ties
  end

  def count_of_games_by_season
    @game_manager.count_of_games_by_season
  end

  def average_goals_per_game
    @game_manager.average_goals_per_game
  end

  def average_goals_by_season
    @game_manager.average_goals_by_season
  end

# ************* LeagueStatistics *************

  def count_of_teams
    @team_manager.count_of_teams
  end

  def best_offense
    @game_team_manager.best_offense
  end

  def worst_offense
    @game_team_manager.worst_offense
  end

  def highest_scoring_visitor
    @game_team_manager.highest_scoring_visitor
  end

  def highest_scoring_home_team
    @game_team_manager.highest_scoring_home_team
  end

  def lowest_scoring_visitor
    @game_team_manager.lowest_scoring_visitor
  end

  def lowest_scoring_home_team
    @game_team_manager.lowest_scoring_home_team
  end

  # ************* SeasonStatistics *************

  def winningest_coach(season_id)
    @game_manager.winningest_coach(season_id)
  end

  def worst_coach(season_id)
    @game_manager.worst_coach(season_id)

  end

  def most_accurate_team(season_id)
    @team_manager.most_accurate_team(season_id)
  end

  def least_accurate_team(season_id)
    @team_manager.least_accurate_team(season_id)
  end

  def most_tackles(season_id)
    @team_manager.most_tackles(season_id)
  end

  def fewest_tackles

  end

  # ************* TeamStatistics *************

  def team_info(team_id)
    @team_manager.team_info(team_id)
  end

  def best_season(team_id)
    @team_manager.best_season(team_id)
  end

  def worst_season(team_id)
    @team_manager.worst_season(team_id)
  end

  def average_win_percentage(team_id)
    @team_manager.average_win_percentage(team_id)
  end

  def most_goals_scored(team_id)
    @team_manager.most_goals_scored(team_id)
  end

  def fewest_goals_scored(team_id)
    @team_manager.fewest_goals_scored(team_id)
  end

  def favorite_opponent(team_id)
    @team_manager.favorite_opponent(team_id)
  end

  def rival(team_id)
    @team_manager.rival(team_id)
  end

end
