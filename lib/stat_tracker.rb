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
    @game_manager.winningest_coach(season_id)
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

  def most_goals_scored

  end

  def fewest_goals_scored

  end

  def favorite_opponent

  end

  def rival

  end


  # **************GameStatistics***********************

  def highest_total_score
    game_score = []
    @games.each do |row|
      game_score << row[6].to_i + row[7].to_i
    end
    game_score.sort!
    game_score[-1]
  end

  def lowest_total_score
    game_score = []
    @games.map do |row|
      game_score << row[6].to_i + row[7].to_i
    end
    game_score.sort!
    game_score[0]
  end

  def percentage_home_wins
    count = @games.count do |row|
      row["home_goals"] > row["away_goals"]
    end
    (count.to_f / @games.count).round(2)
  end

  def percentage_visitor_wins
    count = @games.count do |row|
      row["away_goals"] > row["home_goals"]
    end
    (count.to_f / @games.count).round(2)
  end

  def percentage_ties
    count = @games.count do |row|
      row["away_goals"] == row["home_goals"]
    end
    (count.to_f / @games.count).round(2)
  end

  def season_keys
    @games["season"].uniq
  end

  def count_of_games_by_season
    hash = Hash[self.season_keys.collect {|item| [item, 0]}]
    hash.each do |season, games|
      @games.each do |row|
        if row["season"].include?(season)
          hash[season] += 1
        end
      end
    end
  end

  def average_goals_per_game
    count = @games.map do |row|
      row["away_goals"].to_i + row["home_goals"].to_i
    end
    (count.sum.to_f/ @games["away_goals"].length).round(2)
  end

  def total_goals_by_season
    hash = Hash[self.season_keys.collect {|item| [item, 0]}]
    hash.each do |season, games|
      @games.each do |row|
        if row["season"].include?(season)
          hash[season] += row["away_goals"].to_i + row["home_goals"].to_i
        end
      end
    end
  end

  def average_goals_by_season
    hash = total_goals_by_season
    hash2 = count_of_games_by_season
    hash3 = Hash.new(0)
    hash.each do |season1, goals|
      hash2.each do |season2, games|
        if season2.include?(season1)
          hash3[season2] = (goals/ games.to_f).round(2)
        end
      end
    end
    hash3
  end
end
