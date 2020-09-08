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
      goals_in_game.map(&:to_i).sum.to_f / (goals_in_game.length)
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

  def best_season(team_id)
    #Find all games for that team
    team_games = game_teams.find_all do |game|
      game["team_id"] == team_id
    end

    #Group those games by season
    by_season = team_games.group_by do |game|
      game_info = games.find do |row|
        game["game_id"] == row["game_id"]
      end
      game_info["season"]
    end

    #Calculate win percentage of those seasons
    win_percentage_by_season = {}
    by_season.each do |season, games|
      wins = games.count do |game|
        game["result"] == "WIN"
      end
      win_percentage = (wins / games.count.to_f).round(2)
      win_percentage_by_season[season] = win_percentage
    end

    #Max_by win percentage of seasons
    best_season = win_percentage_by_season.max_by do |season, win_percentage|
      win_percentage
    end

    best_season.first
  end

  def favorite_opponent(team_id)
    #Find all games for that team
    team_games = game_teams.find_all do |game|
      game["team_id"] == team_id
    end

    #Find all opponent games for the team
    opponent_games = team_games.map do |game|
      game_teams.find do |row|
        game["game_id"] == row["game_id"] && row["team_id"] != team_id
      end
    end

    #Group opponent games by opponent
    by_opponent = opponent_games.group_by do |game|
      game["team_id"]
    end

    #Calculate win percentage of those opponents
    win_percentage_by_opponent = {}
    by_opponent.each do |opponent, games|
      wins = games.count do |game|
        game["result"] == "WIN"
      end
      win_percentage = (wins / games.count.to_f).round(2)
      win_percentage_by_opponent[opponent] = win_percentage
    end

    #Min_by win percentage of opponents
    fav_opponent = win_percentage_by_opponent.min_by do |opponent, win_percentage|
      win_percentage
    end

    team_info(fav_opponent.first)["team_name"]
  end
end
