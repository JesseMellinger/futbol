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
