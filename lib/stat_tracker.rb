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
    team_id = group_by(@game_teams, "team_id", "goals").max_by do |team_id, goals_in_game|
      goals_in_game.map(&:to_i).sum.to_f / (goals_in_game.length)
    end.first
    team_info(team_id)["team_name"]
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
end

#   def worst_coach_if_someone_doesnt_have_any_wins_helper
#     worst_coach_array = []
#     total_games_played_by_coach_helper.keys.each do |coach|
#       if !games_won_into_hash_helper.keys.include?(coach)
#         worst_coach_array << coach
#       end
#     end
#     worst_coach_array
#   end
#
#   def worst_coach_if_everyone_has_a_win_helper
#
#     name_of_coach_with_number_variable =
#       coaches_winning_percentage_hash_helper.find_all do |key, value| value == coaches_winning_percentage_hash_helper.values.min
#     end
#     name_of_coach_array_variables = []
#     name_of_coach_with_number_variable.each do |name_and_number|
#     name_of_coach_array_variables << name_and_number[0]
#     end
#   name_of_coach_array_variables
#  end
#
#  def worst_coach
#
#   if worst_coach_if_someone_doesnt_have_any_wins_helper.length == 0
#      worst_coach_if_everyone_has_a_win_helper.join(", ")
#   else
#      worst_coach_if_someone_doesnt_have_any_wins_helper.join(", ")
#   end
# end
#
#   def total_goals_by_team_id_hash_helper
#     total_goals_by_team_hash = {}
#     @game_teams.each do |row|
#       if total_goals_by_team_hash.include?(row[1])
#         total_goals_by_team_hash[row[1]] += row[6].to_i
#       else
#         total_goals_by_team_hash[row[1]] = row[6].to_i
#       end
#     end
#  total_goals_by_team_hash
#   end
#
#   def total_shots_by_team_id_hash_helper
#     total_shots_by_team_hash = {}
#     @game_teams.each do |row|
#       if total_shots_by_team_hash.include?(row[1])
#         total_shots_by_team_hash[row[1]] += row[7].to_i
#       else
#         total_shots_by_team_hash[row[1]] = row[7].to_i
#       end
#     end
#  total_shots_by_team_hash
#   end
#
#   def ratio_of_shots_to_goals_by_team_id_helper
#     total_goals_by_team_id_hash_helper.merge!(total_shots_by_team_id_hash_helper) {|key, value1, value2| (value1.to_f / value2.to_f).round(2)}
#   end
#
#   def highest_win_percentage_by_team_id_helper
#     team_id_with_ratio_of_shot = ratio_of_shots_to_goals_by_team_id_helper.find_all do |key, value|
#       value == ratio_of_shots_to_goals_by_team_id_helper.values.max
#     end
#     team_id_variable = []
#   team_id_with_ratio_of_shot.each do |id_and_ratio|
#   team_id_variable << id_and_ratio[0]
#     end
#     team_id_variable
#   end
#
#   def most_accurate_team
#     team_name = @teams.find do |row|
#       row[0] == highest_win_percentage_by_team_id_helper[0]
#     end
#     team_name[2]
#   end
#
#   def lowest_win_percentage_by_team_id_helper
#
#     team_id_with_ratio_of_shot = ratio_of_shots_to_goals_by_team_id_helper.find_all do |key, value|
#       value == ratio_of_shots_to_goals_by_team_id_helper.values.min
#     end
#     team_id_variable = []
#   team_id_with_ratio_of_shot.each do |id_and_ratio|
#   team_id_variable << id_and_ratio[0]
#     end
#     team_id_variable
#   end
#
#   def least_accurate_team
#     team_name = @teams.find do |row|
#       row[0] == lowest_win_percentage_by_team_id_helper[0]
#     end
#     team_name[2]
#   end
#
#   def total_number_tackles_by_team_id_helper
#
#       total_tackles_by_team_hash = {}
#       @game_teams.each do |row|
#         if total_tackles_by_team_hash.include?(row[1])
#           total_tackles_by_team_hash[row[1]] += row[8].to_i
#         else
#           total_tackles_by_team_hash[row[1]] = row[8].to_i
#         end
#       end
#    total_tackles_by_team_hash
#   end
#
#   def team_id_with_most_tackles_helper
#
#     team_id_with_total_tackles = total_number_tackles_by_team_id_helper.find_all do |key, value|
#       value == total_number_tackles_by_team_id_helper.values.max
#     end
#     team_id_variable = []
#   team_id_with_total_tackles.each do |id_and_ratio|
#   team_id_variable << id_and_ratio[0]
#     end
#     team_id_variable
#   end
#
#   def most_tackles
#     team_name = @teams.find do |row|
#       row[0] == team_id_with_most_tackles_helper[0]
#     end
#     team_name[2]
#   end
#
#   def team_id_with_fewest_tackles_helper
#
#     team_id_with_total_tackles = total_number_tackles_by_team_id_helper.find_all do |key, value|
#       value == total_number_tackles_by_team_id_helper.values.min
#     end
#     team_id_variable = []
#   team_id_with_total_tackles.each do |id_and_ratio|
#   team_id_variable << id_and_ratio[0]
#     end
#     team_id_variable
#   end
#
#   def fewest_tackles
#     team_name = @teams.find do |row|
#       row[0] == team_id_with_fewest_tackles_helper[0]
#     end
#     team_name[2]
#     end
#   end
