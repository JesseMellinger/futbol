require './test/test_helper'
require './lib/game_teams_manager'
require './lib/game_team'
require './lib/stat_tracker'

class GameTeamTest < Minitest::Test

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
    @game_team = @game_team_manager.game_teams[0]
  end

  def test_it_exists
    assert_instance_of GameTeam, @game_team
  end

  def test_it_has_attributes
    assert_equal "2012030221", @game_team.game_id
    assert_equal "3", @game_team.team_id
    assert_equal "away", @game_team.hoa
    assert_equal "LOSS", @game_team.result
    assert_equal "John Tortorella", @game_team.head_coach
    assert_equal "2", @game_team.goals
    assert_equal "8", @game_team.shots
    assert_equal "44", @game_team.tackles
    assert_equal @game_team_manager, @game_team.manager
  end

  def test_it_can_find_opponent
    assert_equal @game_team.game_id, @game_team.opponent.game_id
    refute_equal @game_team.team_id, @game_team.opponent.team_id
  end

end
