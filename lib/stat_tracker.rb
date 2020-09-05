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
      team_id == row[0]
    end

    #Assign hash values
    team_info["team_id"] = team[0]
    team_info["franchise_id"] = team[1]
    team_info["team_name"] = team[2]
    team_info["abbreviation"] = team[3]
    team_info["link"] = team[5]

    team_info
  end
end
