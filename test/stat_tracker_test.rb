require './test/test_helper'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test

  def setup
    @game_path = './data/dummy_game_path.csv'
    @team_path = './data/dummy_team_path.csv'
    @game_teams_path = './data/dummy_game_teams_path.csv'


    @locations = {
      games: @game_path,
      teams: @team_path,
      game_teams: @game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(@locations)
  end

  def test_it_exists
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_read_from_games_file
    assert_equal "Postseason", @stat_tracker.games[0]["type"]
    assert_equal "Toyota Stadium", @stat_tracker.games[1]["venue"]
  end

  def test_read_from_teams_file
    assert_equal "Atlanta United", @stat_tracker.teams[0]["teamName"]
    assert_equal "SeatGeek Stadium", @stat_tracker.teams[1]["Stadium"]
  end

  def test_read_from_game_teams_file
    assert_equal "8", @stat_tracker.game_teams[0]["shots"]
    assert_equal "55.2", @stat_tracker.game_teams[1]["faceOffWinPercentage"]
  end

  # ************* LeagueStatistics Tests *************

  def test_get_number_of_teams
    assert_equal 3, @stat_tracker.count_of_teams
  end

  def test_get_best_offense
    assert_equal "FC Dallas", @stat_tracker.best_offense
  end

# ***************GameStatistics Tests *******************
  def test_highest_total_score
    assert_equal 6, @stat_tracker.highest_total_score
  end

  def test_lowest_total_score
    assert_equal 1, @stat_tracker.lowest_total_score
  end

  def test_percentage_home_wins
    #Percentage of games that a home team has won
    #(rounded to the nearest 100th)
    # float
    assert_equal
  end

  # def test_percentage_visitor_wins
  #   assert_equal
  # end
  #
  # def test_percentage_ties
  #   assert_equal
  #   # Percentage of games that has resulted in a tie (rounded to the nearest 100th)
  #   # float
  # end
  #
  # def test_count_of_games_by_season
  #   # A hash with season names (e.g. 20122013) as keys and counts of games as values
  #   assert_equal
  # end
  #
  # def test_average_goals_per_game
  #   # Average number of goals scored in a game across all seasons including both home and away goals (rounded to the nearest 100th)
  #   assert_equal
  # end
  #
  # def test_average_goals_by_season
  #   Average number of goals scored in a game organized in a hash with season names (e.g. 20122013) as keys and a float representing the average number of goals in a game for that season as values (rounded to the nearest 100th)
  #   assert_equal
  # end
  #

end
