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

def game_id_by_season_helper(season)
  season_by_game_id_hash= {}
  @games.each do |row|
    if row[1] == season
        season_by_game_id_hash[row[0]] = row[1]
      end
    end
   season_by_game_id_hash
 end

  def total_games_played_by_coach_helper(season)
  coaches_total_games_array = []
  season_by_game_id_hash = game_id_by_season_helper(season).keys
  @game_teams.each do |row|
      season_by_game_id_hash.each do |game_id|
        if row[0] == (game_id)
    coaches_total_games_array << row[5]
        end
      end
    end
    coaches_total_games_array.group_by(&:itself)
      games_played_hash.map{|key, value| [key, value.length]}.to_h
  end

  def total_games_played_into_hash_helper(season)

    games_played_hash = total_games_played_by_coach_helper(season).group_by(&:itself)
      games_played_hash.map{|key, value| [key, value.length]}.to_h
  end

  def total_games_won_by_coach_array_helper(season)
    coaches_total_wins_array = []
    season_by_game_id_hash = game_id_by_season_helper(season).keys
    @game_teams.each do |row|
        season_by_game_id_hash.each do |game_id|
          if row[0] == (game_id) && row[3] == "WIN"
      coaches_total_wins_array << row[5]
          end
        end
      end
      coaches_total_wins_array
  end

  def games_won_into_hash_helper(season)
  games_won_hash = total_games_won_by_coach_array_helper(season).group_by(&:itself)
    games_won_hash.map{|key, value| [key, value.length]}.to_h
  end

  def coaches_with_games_played_and_won_array_helper(season)
      coaches_with_games_played_array = total_games_played_by_coach_helper(season)
      coaches_with_games_won_array = games_won_into_hash_helper(season).keys
      coaches_with_games_won_and_played_array = coaches_with_games_played_array & coaches_with_games_won_array
      coaches_with_games_won_and_played_array
  end

  def coaches_winning_percentage_hash_helper(season)
    coaches_winning_percentage_hash = {}
    coaches_with_games_played_and_won_array_helper(season).each do |coach|

    coaches_winning_percentage_hash[coach] = ((games_won_into_hash_helper(season)[coach].to_f / total_games_played_into_hash_helper(season)[coach].to_f * 100))
    end
    coaches_winning_percentage_hash
  end

  def winningest_coach(season)
    name_of_coach_with_number_variable = coaches_winning_percentage_hash_helper(season).find_all do |key, value|
      value == coaches_winning_percentage_hash_helper(season).values.max
      coaches_winning_percentage_hash_helper(season).key(name_of_coach_with_number_variable)
    end
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
