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

  def test_it_has_games_by_season
    game_1 = mock
    game_2 = mock
    game_3 = mock
    game_1.stubs(:season).returns("20122013")
    game_2.stubs(:season).returns("20122013")
    game_3.stubs(:season).returns("20132014")
    game_1.stubs(:game_id).returns("1")
    game_2.stubs(:game_id).returns("2")
    game_3.stubs(:game_id).returns("3")


    @team.stubs(:games).returns([game_1, game_2, game_3])
    @team.stubs(:team_games).returns([game_1, game_2, game_3])

    expected = {
      "20122013" => [game_1, game_2],
      "20132014" => [game_3]
    }
    assert_equal expected, @team.games_by_season
  end

  def test_it_has_team_games
    assert_equal 463, @team.team_games.count
  end

  def test_it_has_games
    assert_equal 463, @team.games.count
  end

  def test_it_has_average_win_percentage
    team = @team_manager.teams[4]
    assert_equal 0.49, team.average_win_percentage
  end

  def test_most_goals_scored
    team = @team_manager.find_team("18")
    assert_equal 7, team.most_goals_scored
  end

  def test_fewest_goals_scored
    team = @team_manager.find_team("18")
    assert_equal 0, team.fewest_goals_scored
  end

  def test_favorite_opponent
    team = @team_manager.find_team("18")
    assert_equal "DC United", team.favorite_opponent
  end

  def test_it_has_a_rival
    team = @team_manager.find_team("18")
    assert_equal "LA Galaxy", team.rival
  end

  def test_it_has_opponents_by_win_percentage
    team = @team_manager.find_team("18")
    expected = {
      "19"=>0.44, "52"=>0.45, "21"=>0.38, "20"=>0.39,
      "17"=>0.64, "29"=>0.4, "25"=>0.37, "16"=>0.37,
      "30"=>0.41, "1"=>0.4, "8"=>0.3, "23"=>0.39,
      "3"=>0.3, "14"=>0.0, "15"=>0.5, "28"=>0.44,
      "22"=>0.22, "24"=>0.26, "5"=>0.56, "2"=>0.4,
      "26"=>0.44, "7"=>0.3, "27"=>0.33, "6"=>0.3,
      "13"=>0.6, "10"=>0.5, "9"=>0.2, "12"=>0.4, 
      "54"=>0.33, "4"=>0.2, "53"=>0.25
     }
     assert_equal expected, team.opponents_by_win_percentage
  end

end
