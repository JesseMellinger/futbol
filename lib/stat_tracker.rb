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

  # ************** Team Statistics **************

  def team_info(team_id)
    team_info = {}

    #Find the team's row information
    team = teams.find do |row|
      team_id == row["team_id"]
    end

    #Assign hash values
    team_info["team_id"] = team["team_id"]
    team_info["franchise_id"] = team["franchiseId"]
    team_info["team_name"] = team["teamName"]
    team_info["abbreviation"] = team["abbreviation"]
    team_info["link"] = team["link"]

    team_info
  end
end
