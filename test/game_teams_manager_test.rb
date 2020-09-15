require './test/test_helper'
require './lib/game_teams_manager'
require './lib/stat_tracker'
require './lib/game_manager'

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
    @game_data = @stat_tracker.load_csv(@locations[:games])
    @team_data = @stat_tracker.load_csv(@locations[:teams])
    @game_team_manager = GameTeamManager.new(@data, @stat_tracker)
    @game_manager = GameManager.new(@game_data, @stat_tracker)
    @team_manager = TeamManager.new(@team_data, @stat_tracker)
    @team = @team_manager.teams

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

  def test_get_highest_scoring_home_team
    assert_equal "Reign FC", @game_team_manager.highest_scoring_home_team
  end

  def test_get_lowest_scoring_visitor
    assert_equal "San Jose Earthquakes", @game_team_manager.lowest_scoring_visitor
  end

  def test_get_lowest_scoring_home_team
    assert_equal "Utah Royals FC", @game_team_manager.lowest_scoring_home_team
  end

  def test_get_all_home_or_away_games
    assert @game_team_manager.find_all_home_or_away_games("away").all? do |game_team|
      game_team.hoa == "away"
    end
    assert @game_team_manager.find_all_home_or_away_games("home").all? do |game_team|
      game_team.hoa == "home"
    end
  end

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

  def test_winningest_coach
    game_id_array = @game_manager.find_game_ids_of_season("20142015")
    season_games = @game_team_manager.find_season_by_game_ids(game_id_array)
    coach_results = @game_team_manager.group_season_games_by_coach_results(season_games)
    @game_team_manager.coach_with_greatest_win_percentage(coach_results)

    assert_equal "Alain Vigneault", @game_team_manager.winningest_coach(game_id_array)
  end

  def test_worst_coach
    game_id_array = @game_manager.find_game_ids_of_season("20142015")
    season_games = @game_team_manager.find_season_by_game_ids(game_id_array)
    coach_results = @game_team_manager.group_season_games_by_coach_results(season_games)
    @game_team_manager.coach_with_worst_win_percentage(coach_results)

    assert_equal "Ted Nolan", @game_team_manager.worst_coach(game_id_array)
  end

  def test_find_season_by_game_ids
    game_id_array = @game_manager.find_game_ids_of_season("20142015")

    assert_equal 2638, @game_team_manager.find_season_by_game_ids(game_id_array).length
  end

  def test_group_season_games_by_coach_results
    game_id_array = @game_manager.find_game_ids_of_season("20142015")
    season_games = @game_team_manager.find_season_by_game_ids(game_id_array)

    assert_equal 35, @game_team_manager.group_season_games_by_coach_results(season_games).length
  end

  def test_coach_with_greatest_win_percentage
    game_id_array = @game_manager.find_game_ids_of_season("20142015")
    season_games = @game_team_manager.find_season_by_game_ids(game_id_array)
    coach_results = @game_team_manager.group_season_games_by_coach_results(season_games)

    assert_equal "Alain Vigneault", @game_team_manager.coach_with_greatest_win_percentage(coach_results)
  end

  def test_coach_with_worst_win_percentage
    game_id_array = @game_manager.find_game_ids_of_season("20142015")
    season_games = @game_team_manager.find_season_by_game_ids(game_id_array)
    coach_results = @game_team_manager.group_season_games_by_coach_results(season_games)

    assert_equal "Ted Nolan", @game_team_manager.coach_with_worst_win_percentage(coach_results)
  end

  def test_most_accurate_team
    game_id_array = @game_manager.find_game_ids_of_season("20142015")

    assert_equal "Toronto FC", @game_team_manager.most_accurate_team(game_id_array)
  end

  def test_least_accurate_team
    game_id_array = @game_manager.find_game_ids_of_season("20142015")

    assert_equal "Columbus Crew SC", @game_team_manager.least_accurate_team(game_id_array)
  end

  def test_most_accurate_team_id
    game_id_array = @game_manager.find_game_ids_of_season("20142015")
    most_accurate_team = @game_team_manager.most_accurate_team(game_id_array)
    most_accurate_team_id = @team_manager.teams.find {|team| team.team_name == most_accurate_team}.team_id

    assert_equal "20", most_accurate_team_id
  end

  def test_least_accurate_id
    game_id_array = @game_manager.find_game_ids_of_season("20142015")
    least_accurate_team = @game_team_manager.least_accurate_team(game_id_array)
    least_accurate_team_id = @team_manager.teams.find {|team| team.team_name == least_accurate_team}.team_id

    assert_equal "53", least_accurate_team_id
  end

  def test_it_can_find_opponent_of_a_game
    game1 = mock
    game2 = mock
    game3 = mock
    game1.stubs(:game_id).returns("0000")
    game2.stubs(:game_id).returns("0000")
    game3.stubs(:game_id).returns("0001")
    game1.stubs(:team_id).returns("1")
    game2.stubs(:team_id).returns("2")
    game3.stubs(:team_id).returns("1")

    @game_team_manager.stubs(:game_teams).returns([game1, game2, game3])

    assert_equal game2, @game_team_manager.opponent(game1)
  end
end
