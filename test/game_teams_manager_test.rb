require './test/test_helper'
require './lib/game_teams_manager'
require './lib/stat_tracker'

class GameTeamManagerTest < Minitest::Test

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
    @data = @stat_tracker.load_csv(@locations[:game_teams])
    @game_team_manager = GameTeamManager.new(@data, @stat_tracker)

  end

  def test_it_exists
    assert_instance_of GameTeamManager, @game_team_manager
  end

  def test_it_has_attributes
    assert_equal 14882, @game_team_manager.game_teams.length
    assert_equal @stat_tracker, @game_team_manager.tracker
  end

  def test_get_best_offense
    assert_equal "Reign FC", @game_team_manager.best_offense
  end

  def test_get_worst_offense
    assert_equal "Utah Royals FC", @game_team_manager.worst_offense
  end

  def test_get_highest_scoring_visitor
    assert_equal "FC Dallas", @game_team_manager.highest_scoring_visitor
  end

  def test_get_all_home_or_away_games
    assert @game_team_manager.find_all_home_or_away_games("away").all? do |game_team|
      game_team.hoa == "away"
    end
    assert @game_team_manager.find_all_home_or_away_games("home").all? do |game_team|
      game_team.hoa == "home"
    end
  end

<<<<<<< HEAD
=======
  def test_get_all_game_by_team
    assert @game_team_manager.find_games_by_team("1").all? do |game_team|
      game_team.team_id == "1"
    end
  end

  def test_it_can_calculate_win_percentage
    game_1 = mock
    game_2 = mock
    game_3 = mock
    game_1.stubs(:result).returns("WIN")
    game_2.stubs(:result).returns("WIN")
    game_3.stubs(:result).returns("LOSS")

    games = [game_1, game_2, game_3]
    assert_equal 0.67, @game_team_manager.win_percentage(games)
  end

>>>>>>> 13104dee18616514decd3d05347e6745bbb79e85
end
