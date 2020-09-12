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
    skip
    assert_equal "Postseason", @stat_tracker.games[0]["type"]
    assert_equal "Toyota Stadium", @stat_tracker.games[1]["venue"]
  end

  def test_read_from_teams_file
    skip
    assert_equal "Atlanta United", @stat_tracker.teams[0]["teamName"]
    assert_equal "SeatGeek Stadium", @stat_tracker.teams[1]["Stadium"]
  end

  def test_read_from_game_teams_file
    skip
    assert_equal "8", @stat_tracker.game_teams[0]["shots"]
    assert_equal "55.2", @stat_tracker.game_teams[1]["faceOffWinPercentage"]
  end

  # ************* LeagueStatistics Tests *************

  def test_get_number_of_teams
    assert_equal 32, @stat_tracker.count_of_teams
  end

  def test_get_best_offense
    assert_equal "Reign FC", @stat_tracker.best_offense
  end

end
