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
    assert_equal "Utah Royals FC", @stat_tracker.worst_offense
  end

  def test_get_all_home_or_away_games
    assert @game_team_manager.find_all_home_or_away_games("away").all? do |game_team|
      game_team.hoa == "away"
    end
    assert @game_team_manager.find_all_home_or_away_games("home").all? do |game_team|
      game_team.hoa == "home"
    end
  end

end
