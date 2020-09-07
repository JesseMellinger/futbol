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
# ************* Season Statistics *************
  def total_games_played_by_coach_helper
    games_coached_hash =  @game_teams["head_coach"].group_by(&:itself)
        games_coached_hash.map{|key, value| [key, value.length]}.to_h
      end

  def total_games_won_by_coach_array_helper
    games_won_array = []
    @game_teams.each do |row|
      if row[3] == "WIN"
        games_won_array << row[5]
      end
    end
    games_won_array
  end

  def games_won_into_hash_helper
  games_won_hash = total_games_won_by_coach_array_helper.group_by(&:itself)
    games_won_hash.map{|key, value| [key, value.length]}.to_h
  end

  def coaches_with_games_played_and_won_array_helper
      coaches_with_games_played_array = total_games_played_by_coach_helper.keys
      coaches_with_games_won_array = games_won_into_hash_helper.keys
      coaches_with_games_won_and_played_array = coaches_with_games_played_array & coaches_with_games_won_array
      coaches_with_games_won_and_played_array
  end

  def coaches_winning_percentage_hash_helper
    coaches_winning_percentage_hash = {}
    coaches_with_games_played_and_won_array_helper.each do |coach|

      coaches_winning_percentage_hash[coach] = ((games_won_into_hash_helper[coach] / total_games_played_by_coach_helper[coach] * 100))
    end
    coaches_winning_percentage_hash
  end

  def winningest_coach
    name_of_coach_with_number_variable = coaches_winning_percentage_hash_helper.find_all do |key, value|
      value == coaches_winning_percentage_hash_helper.values.max
    end
    name_of_coach_array_variable = []
  name_of_coach_with_number_variable.each do |name_and_number|
  name_of_coach_array_variable << name_and_number[0]
    end
    name_of_coach_array_variable.join(", ")
  end

  def worst_coach_if_someone_doesnt_have_any_wins_helper
    worst_coach_array = []
    total_games_played_by_coach_helper.keys.each do |coach|
      if !games_won_into_hash_helper.keys.include?(coach)
        worst_coach_array << coach
      end
    end
    worst_coach_array
  end

  def worst_coach_if_everyone_has_a_win_helper

    name_of_coach_with_number_variable =
      coaches_winning_percentage_hash_helper.find_all do |key, value| value == coaches_winning_percentage_hash_helper.values.min
    end
    name_of_coach_array_variables = []
    name_of_coach_with_number_variable.each do |name_and_number|
    name_of_coach_array_variables << name_and_number[0]
    end
  name_of_coach_array_variables
 end

 def worst_coach

  if worst_coach_if_someone_doesnt_have_any_wins_helper.length == 0
     worst_coach_if_everyone_has_a_win_helper.join(", ")
  else
     worst_coach_if_someone_doesnt_have_any_wins_helper.join(", ")
  end
end

  def total_goals_by_team_id_hash_helper
    total_goals_by_team_hash = {}
    @game_teams.each do |row|
      if total_goals_by_team_hash.include?(row[1])
        total_goals_by_team_hash[row[1]] += row[6].to_i
      else
        total_goals_by_team_hash[row[1]] = row[6].to_i
      end
    end
 total_goals_by_team_hash
  end

  def total_shots_by_team_id_hash_helper
    total_shots_by_team_hash = {}
    @game_teams.each do |row|
      if total_shots_by_team_hash.include?(row[1])
        total_shots_by_team_hash[row[1]] += row[7].to_i
      else
        total_shots_by_team_hash[row[1]] = row[7].to_i
      end
    end
 total_shots_by_team_hash
  end

  def ratio_of_shots_to_goals_by_team_id_helper
    total_goals_by_team_id_hash_helper.merge!(total_shots_by_team_id_hash_helper) {|key, value1, value2| (value1.to_f / value2.to_f).round(2)}
  end

  def highest_win_percentage_by_team_id_helper
    team_id_with_ratio_of_shot = ratio_of_shots_to_goals_by_team_id_helper.find_all do |key, value|
      value == ratio_of_shots_to_goals_by_team_id_helper.values.max
    end
    team_id_variable = []
  team_id_with_ratio_of_shot.each do |id_and_ratio|
  team_id_variable << id_and_ratio[0]
    end
    team_id_variable
  end

  def most_accurate_team
    team_name = @teams.find do |row|
      row[0] == highest_win_percentage_by_team_id_helper[0]
    end
    team_name[2]
  end

  def lowest_win_percentage_by_team_id_helper

    team_id_with_ratio_of_shot = ratio_of_shots_to_goals_by_team_id_helper.find_all do |key, value|
      value == ratio_of_shots_to_goals_by_team_id_helper.values.min
    end
    team_id_variable = []
  team_id_with_ratio_of_shot.each do |id_and_ratio|
  team_id_variable << id_and_ratio[0]
    end
    team_id_variable
  end

  def name_of_least_accurate_team
    team_name = @teams.find do |row|
      row[0] == lowest_win_percentage_by_team_id_helper[0]
    end
    team_name[2]
  end

  def total_number_tackles_by_team_id_helper

      total_tackles_by_team_hash = {}
      @game_teams.each do |row|
        if total_tackles_by_team_hash.include?(row[1])
          total_tackles_by_team_hash[row[1]] += row[8].to_i
        else
          total_tackles_by_team_hash[row[1]] = row[8].to_i
        end
      end
   total_tackles_by_team_hash
  end

  def team_id_with_most_tackles_helper

    team_id_with_total_tackles = total_number_tackles_by_team_id_helper.find_all do |key, value|
      value == total_number_tackles_by_team_id_helper.values.max
    end
    team_id_variable = []
  team_id_with_total_tackles.each do |id_and_ratio|
  team_id_variable << id_and_ratio[0]
    end
    team_id_variable
  end

  def most_tackles
    team_name = @teams.find do |row|
      row[0] == team_id_with_most_tackles_helper[0]
    end
    team_name[2]
  end
end
