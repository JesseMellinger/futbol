require './test/test_helper'
require './lib/game_manager'
require './lib/stat_tracker'

class GameManagerTest < Minitest::Test

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
    @data = @stat_tracker.load_csv(@locations[:games])
    @game_manager = GameManager.new(@data, @stat_tracker)
  end

  def test_it_exists
    assert_instance_of GameManager, @game_manager
  end

  def test_it_has_attributes
    assert_equal 7441, @game_manager.games.length
    assert_equal @stat_tracker, @game_manager.tracker
  end

  def test_get_all_game_by_team
    assert @game_manager.find_games_by_team("1").all? do |game|
      game.away_team_id == "1" || game.home_team_id == "1"
    end
  end

  def test_worst_coach
    assert_equal "Ted Nolan", @game_manager.worst_coach("20142015")
    assert_equal "Peter Laviolette", @game_manager.worst_coach("20132014")
  end

  def test_find_game_ids_of_season

    assert_equal 1319, @game_manager.find_game_ids_of_season("20142015").length
  end

  def test_highest_total_score
    assert_equal 11, @game_manager.highest_total_score
  end

  def test_lowest_total_score
    assert_equal 0, @game_manager.lowest_total_score
  end

  def test_percentage_home_wins
    assert_equal 0.44, @game_manager.percentage_home_wins
  end
end
