require './test/test_helper'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test

  def setup
    @game_path = './data/games.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './data/game_teams.csv'


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

  # def test_get_number_of_teams
  #   assert_equal 3, @stat_tracker.count_of_teams
  # end
  #
  # def test_get_best_offense
  #   assert_equal "FC Dallas", @stat_tracker.best_offense
  # end

# ***************GameStatistics Tests *******************
  def test_highest_total_score
    assert_equal 11, @stat_tracker.highest_total_score
  end

  def test_lowest_total_score
    assert_equal 0, @stat_tracker.lowest_total_score
  end

  def test_percentage_home_wins
    assert_equal 0.44, @stat_tracker.percentage_home_wins
  end

  def test_percentage_visitor_wins
    assert_equal 0.36, @stat_tracker.percentage_visitor_wins
  end

  def test_percentage_ties
    assert_equal 0.20, @stat_tracker.percentage_ties
  end

  def test_season_keys
    expected = ["20122013", "20162017", "20142015", "20152016",
      "20132014", "20172018"]
    assert_equal expected, @stat_tracker.season_keys
  end

  def test_count_of_games_by_season
    expected = {"20122013"=>806,
      "20162017"=>1317,
      "20142015"=>1319,
      "20152016"=>1321,
      "20132014"=>1323,
      "20172018"=>1355}
    assert_equal expected, @stat_tracker.count_of_games_by_season
  end

  def test_average_goals_per_game
    assert_equal 4.22, @stat_tracker.average_goals_per_game
  end

  def test_total_goals_by_season
    expected = {"20122013"=> 3322,
      "20162017"=> 5565,
      "20142015"=> 5461,
      "20152016"=> 5499,
      "20132014"=> 5547,
      "20172018"=> 6019}
    assert_equal expected, @stat_tracker.total_goals_by_season
  end

  def test_average_goals_by_season
    expected = {"20122013"=>4.12,
      "20162017"=>4.23,
      "20142015"=>4.14,
      "20152016"=>4.16,
      "20132014"=>4.19,
      "20172018"=>4.44}
    assert_equal expected, @stat_tracker.average_goals_by_season
  end


end
