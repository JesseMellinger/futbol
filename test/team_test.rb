require './test/test_helper'
require './lib/team_manager'
require './lib/team'
require './lib/stat_tracker'

class TeamTest < Minitest::Test

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
    @team = @team_manager.teams[0]
  end

  def test_it_exists
    assert_instance_of Team, @team
  end

  def test_it_has_attributes
    assert_equal "1", @team.team_id
    assert_equal "23", @team.franchise_id
    assert_equal "Atlanta United", @team.team_name
    assert_equal "ATL", @team.abbreviation
    assert_equal "/api/v1/teams/1", @team.link
    assert_equal @team_manager, @team.manager
  end

  def test_it_has_team_info
    expected = {
      "team_id" => "1",
      "franchise_id" => "23",
      "team_name" => "Atlanta United",
      "abbreviation" => "ATL",
      "link" => "/api/v1/teams/1"
    }
    assert_equal expected, @team.team_info
  end

  def test_it_has_a_best_season
    team = @team_manager.teams[4]
    assert_equal "20132014", team.best_season
  end

  def test_it_has_a_worst_season
    team = @team_manager.teams[4]
    assert_equal "20142015", team.worst_season
  end

  def test_it_has_seasons_by_win_percentage
    team = @team_manager.teams[4]
    expected = {
      "20122013"=>0.54,
      "20172018"=>0.53,
      "20132014"=>0.57,
      "20142015"=>0.38,
      "20152016"=>0.4,
      "20162017"=>0.51
     }
     assert_equal expected, team.seasons_by_win_percentage
  end

end
