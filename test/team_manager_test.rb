require './test/test_helper'
require './lib/team_manager'
require './lib/stat_tracker'

class TeamManagerTest < Minitest::Test

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
    @data = @stat_tracker.load_csv(@locations[:teams])
    @team_manager = TeamManager.new(@data, @stat_tracker)

  end

  def test_it_exists
    assert_instance_of TeamManager, @team_manager
  end

  def test_it_has_attributes
    assert_equal 32, @team_manager.teams.length
    assert_equal @stat_tracker, @team_manager.tracker
  end

  def test_it_can_find_team
    assert_instance_of Team, @team_manager.find_team("4")
    assert_equal "4", @team_manager.find_team("4").team_id
  end

  def test_it_has_team_info
    expected = {
      "team_id" => "4",
      "franchise_id" => "16",
      "team_name" => "Chicago Fire",
      "abbreviation" => "CHI",
      "link" => "/api/v1/teams/4"
    }
    assert_equal expected, @team_manager.team_info("4")
  end

  def test_it_has_a_best_season
    assert_equal "20132014", @team_manager.best_season("6")
  end

  def test_it_has_a_worst_season
    assert_equal "20142015", @team_manager.worst_season("6")
  end

  def test_it_has_average_win_percentage
    assert_equal 0.49, @team_manager.average_win_percentage("6")
  end

  def test_it_can_calculate_win_percentage
    game_1 = mock
    game_2 = mock
    game_3 = mock
    game_1.stubs(:result).returns("WIN")
    game_2.stubs(:result).returns("WIN")
    game_3.stubs(:result).returns("LOSS")

    games = [game_1, game_2, game_3]
    assert_equal 0.67, @team_manager.win_percentage(games)
  end

  def test_most_accurate_team
    assert_equal "Toronto FC", @team_manager.most_accurate_team("20142015")
    assert_equal "Real Salt Lake", @team_manager.most_accurate_team("20132014")
  end

  def test_least_accurate_team
    assert_equal "Columbus Crew SC", @team_manager.least_accurate_team("20142015")
    assert_equal "New York City FC", @team_manager.least_accurate_team("20132014")
  end

  def test_most_goals_scored
    assert_equal 7, @team_manager.most_goals_scored("18")
  end

  def test_fewest_goals_scored
    assert_equal 0, @team_manager.fewest_goals_scored("18")
  end

  def test_favorite_opponent
    assert_equal "DC United", @team_manager.favorite_opponent("18")
  end

  def test_it_has_a_rival
    assert_equal "LA Galaxy", @team_manager.rival("18")
  end

  def test_most_tackles
    assert_equal "FC Cincinnati", @team_manager.most_tackles("20132014")
    assert_equal "Seattle Sounders FC", @team_manager.most_tackles("20142015")
  end

  def test_fewest_tackles
    assert_equal "Atlanta United", @team_manager.fewest_tackles("20132014")
    assert_equal "Orlando City SC", @team_manager.fewest_tackles("20142015")
  end
end
