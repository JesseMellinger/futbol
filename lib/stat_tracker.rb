require 'csv'

class StatTracker
  attr_reader :games, :teams, :game_teams

  def initialize(games, teams, game_teams)
    @games = games
    @teams = teams
    @game_teams = game_teams
  end

  def self.from_csv(locations)
    games = read_from_file(locations[:games])
    teams = read_from_file(locations[:teams])
    game_teams = read_from_file(locations[:game_teams])
    stat_tracker = self.new(games, teams, game_teams)
  end

  def self.read_from_file(file)
    CSV.parse(File.read(file), headers: true)
  end

# ************* LeagueStatistics *************

  def group_by(data, key, value)
    hash = {}
    data = self.instance_variable_get(data)
    data.each do |row|
      if hash[row[key]]
        hash[row[key]] << row[value]
      else
        hash[row[key]] = [row[value]]
      end
    end
    hash
  end

  def count_of_teams
    @teams["teamName"].count
  end

  def best_offense
    team_id = group_by(:@game_teams, "team_id", "goals").max_by do |team_id, goals_in_game|
      goals_in_game.map(&:to_i).sum / (goals_in_game.length)
    end.first
    @teams.find {|row| row["team_id"] == team_id}["teamName"]
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
    count.to_f / @games.count.round(2)
  end

  def percentage_visitor_wins
    count = @games.count do |row|
      row["away_goals"] > row["home_goals"]
    end
    count.to_f / @games.count.round(2)
  end

  def percentage_ties
    count = @games.count do |row|
      row["away_goals"] == row["home_goals"]
    end
    count.to_f / @games.count.round(2)
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
    count.sum.to_f/ @games["away_goals"].length.round(2)
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
          hash3[season2] = goals/ games.to_f.round(2)
        end
      end
    end
    hash3
  end
end
