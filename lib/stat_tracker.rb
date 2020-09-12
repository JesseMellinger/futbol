require 'csv'
require './lib/team_manager'
require './lib/game_manager'
require './lib/game_teams_manager'

class StatTracker

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

  end

  def lowest_total_score

  end

  def percentage_home_wins

  end

  def percentage_ties

  end

  def count_of_games_by_season

  end

  def average_goals_per_game

  end

  def average_goals_by_season

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
    
  end

  def worst_coach

  end

  def most_accurate_team

  end

  def least_accurate_team

  end

  def most_tackles

  end

  def fewest_tackles

  end

  # ************* TeamStatistics *************

  def team_info

  end

  def best_season

  end

  def worst_season

  end

  def average_win_percentage

  end

  def most_goals_scored

  end

  def fewest_goals_scored

  end

  def favorite_opponent

  end

  def rival

  end

end
