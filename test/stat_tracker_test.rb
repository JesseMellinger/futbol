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

  def test_it_can_load_managers
    assert_instance_of TeamManager, @stat_tracker.team_manager
    assert_instance_of GameManager, @stat_tracker.game_manager
    assert_instance_of GameTeamManager, @stat_tracker.game_team_manager
  end

  def test_it_can_load_csv
    assert_instance_of CSV::Table, @stat_tracker.load_csv(@locations[:teams])
  end

  # ************* LeagueStatistics Tests *************

  def test_get_number_of_teams
    assert_equal 32, @stat_tracker.count_of_teams
  end

  def test_get_best_offense
    assert_equal "Reign FC", @stat_tracker.best_offense
  end

  def test_get_worst_offense
    assert_equal "Utah Royals FC", @stat_tracker.worst_offense
  end

  def test_get_highest_scoring_visitor
    assert_equal "FC Dallas", @stat_tracker.highest_scoring_visitor
  end

  # ************* Team Statistics Tests *************

  def test_it_has_team_info
    expected = {
      "team_id" => "4",
      "franchise_id" => "16",
      "team_name" => "Chicago Fire",
      "abbreviation" => "CHI",
      "link" => "/api/v1/teams/4"
    }
    assert_equal expected, @stat_tracker.team_info("4")
  end

  def test_it_has_a_best_season
    assert_equal "20132014", @stat_tracker.best_season("6")
  end

  def test_it_has_a_worst_season
    assert_equal "20142015", @stat_tracker.worst_season("6")
  end

  def test_it_has_average_win_percentage
    assert_equal 0.49, @stat_tracker.average_win_percentage("6")
  end

end
