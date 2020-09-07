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



end
