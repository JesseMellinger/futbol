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
# ************* Season Statistics *************

  def winningest_coach(season_id)
    # Find all games in season & return array of those games' ids"
    season_games = @games.find_all do |game|
      game["season"] == season_id
    end.map {|game| game["game_id"]}

    # Find all those games in @game_teams & return array of CSV row objects
    season_games = @game_teams.find_all do |game|
      season_games.include?(game["game_id"])
    end

    # Creates hash with 'head_coach' as key and value as an array with first
    # element as integer of games won and second element integer of all other games (losses or ties)
    season_games = season_games.group_by do |game|
      game["head_coach"]
    end.transform_values! {|games| games.partition {|game| game["result"] == "WIN"}.map(&:length)}

    # Returns name of coach with greatest win percentage (games won divided by total of games played)
    season_games.max_by do |coach, games|
      games[0].to_f / games.sum
    end.first
  end

  def worst_coach(season_id)
    # Find all games in season & return array of those games' ids
    season_games = @games.find_all do |game|
      game["season"] == season_id
    end.map {|game| game["game_id"]}

    # Find all those games in @game_teams & return array of CSV row objects
    season_games = @game_teams.find_all do |game|
      season_games.include?(game["game_id"])
    end

    # Creates hash with 'head_coach' as key and value as an array with first
    # element as integer of games won and second element integer of all other games (losses or ties)
    season_games = season_games.group_by do |game|
      game["head_coach"]
    end.transform_values! {|games| games.partition {|game| game["result"] == "WIN"}.map(&:length)}

    # Returns name of coach with greatest win percentage (games won divided by total of games played)
    season_games.min_by do |coach, games|
      games[0].to_f / games.sum
    end.first
  end

  def most_accurate_team(season_id)
    # Find all games in season & return array of those games' ids"
  season_games = @games.find_all do |game|
    game["season"] == season_id
  end.map {|game| game["game_id"]}

  # Find all those games in @game_teams & return array of CSV row objects
  season_games = @game_teams.find_all do |game|
    season_games.include?(game["game_id"])
  end

  # Creates hash with 'team_id' as key and value as total shots taken for the season
  total_shots_by_team = {}
    season_games.each do |game|
    if total_shots_by_team.include?(game["team_id"])
      total_shots_by_team[game["team_id"]] += game["shots"].to_i
    else
      total_shots_by_team[game["team_id"]] = game["shots"].to_i
      end
    end

  #Creates hash with 'team_id' as key and value as total goals for the season
  total_goals_by_team = {}
    season_games.each do |game|
    if total_goals_by_team.include?(game["team_id"])
      total_goals_by_team[game["team_id"]] += game["goals"].to_i
    else
      total_goals_by_team[game["team_id"]] = game["goals"].to_i
      end
    end

  #Creates hash with 'team_id' as key and values of shot-to-goal ratio
  shots_to_goal_ratio = total_goals_by_team.merge!(total_shots_by_team) {|key, value1, value2|
    (value1.to_f / value2.to_f).round(3)}

  #returns the team_id of team with best shot-to-goal ratio
  highest_ratio = shots_to_goal_ratio.values.max
  team_with_highest_ratio = shots_to_goal_ratio.key(highest_ratio)

  #returns team name of team with best shot-to-goal ratio
  team_name = @teams.find do |row|
    row["team_id"] == team_with_highest_ratio
     end
  team_name[2]
  end

  def least_accurate_team(season_id)
    # Find all games in season & return array of those games' ids"
  season_games = @games.find_all do |game|
    game["season"] == season_id
  end.map {|game| game["game_id"]}

  # Find all those games in @game_teams & return array of CSV row objects
  season_games = @game_teams.find_all do |game|
    season_games.include?(game["game_id"])
  end

  # Creates hash with 'team_id' as key and value as total shots taken for the season
  total_shots_by_team = {}
    season_games.each do |game|
    if total_shots_by_team.include?(game["team_id"])
      total_shots_by_team[game["team_id"]] += game["shots"].to_i
    else
      total_shots_by_team[game["team_id"]] = game["shots"].to_i
      end
    end

  #Creates hash with 'team_id' as key and value as total goals for the season
  total_goals_by_team = {}
    season_games.each do |game|
    if total_goals_by_team.include?(game["team_id"])
      total_goals_by_team[game["team_id"]] += game["goals"].to_i
    else
      total_goals_by_team[game["team_id"]] = game["goals"].to_i
      end
    end

  #Creates hash with 'team_id' as key and values of shot-to-goal ratio
  shots_to_goal_ratio = total_goals_by_team.merge!(total_shots_by_team) {|key, value1, value2|
    (value1.to_f / value2.to_f).round(6)}

  #returns the team_id of team with best shot-to-goal ratio
  lowest_ratio = shots_to_goal_ratio.values.min
  team_with_lowest_ratio = shots_to_goal_ratio.key(lowest_ratio)

  #returns team name of team with best shot-to-goal ratio
  team_name = @teams.find do |row|
    row["team_id"] == team_with_lowest_ratio
     end
  team_name[2]
    end

  def most_tackles(season_id)
    # Find all games in season & return array of those games' ids"
    season_games = @games.find_all do |game|
      game["season"] == season_id
    end.map {|game| game["game_id"]}

    # Find all those games in @game_teams & return array of CSV row objects
    season_games = @game_teams.find_all do |game|
    season_games.include?(game["game_id"])
    end

    #Creates hash with team_id as key and total tackles in the season as value
    total_tackles_by_team = {}
      season_games.each do |game|
      if total_tackles_by_team.include?(game["team_id"])
        total_tackles_by_team[game["team_id"]] += game["tackles"].to_i
      else
        total_tackles_by_team[game["team_id"]] = game["tackles"].to_i
      end
    end

    #returns the team_id of team with the most tackles
    most_tackles = total_tackles_by_team.values.max
    team_with_most_tackles = total_tackles_by_team.key(most_tackles)

    #returns team name of team with best shot-to-goal ratio
    team_name = @teams.find do |row|
      row["team_id"] == team_with_most_tackles
       end
    team_name[2]
    end

  def fewest_tackles(season_id)
      # Find all games in season & return array of those games' ids"
    season_games = @games.find_all do |game|
      game["season"] == season_id
    end.map {|game| game["game_id"]}

      # Find all those games in @game_teams & return array of CSV row objects
    season_games = @game_teams.find_all do |game|
      season_games.include?(game["game_id"])
      end

      #Creates hash with team_id as key and total tackles in the season as value
    total_tackles_by_team = {}
      season_games.each do |game|
      if total_tackles_by_team.include?(game["team_id"])
        total_tackles_by_team[game["team_id"]] += game["tackles"].to_i
      else
        total_tackles_by_team[game["team_id"]] = game["tackles"].to_i
      end
    end

      #returns the team_id of team with the most tackles
    fewest_tackles = total_tackles_by_team.values.min
    team_with_fewest_tackles = total_tackles_by_team.key(fewest_tackles)

      #returns team name of team with best shot-to-goal ratio
    team_name = @teams.find do |row|
      row["team_id"] == team_with_fewest_tackles
    end
    team_name[2]
  end
end
