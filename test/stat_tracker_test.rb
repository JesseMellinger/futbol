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

  def test_get_highest_scoring_home_team
    assert_equal "Reign FC", @stat_tracker.highest_scoring_home_team
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

  def test_most_goals_scored
    assert_equal 7, @stat_tracker.most_goals_scored("18")
  end

  def test_fewest_goals_scored
    assert_equal 0, @stat_tracker.fewest_goals_scored("18")
  end

  def test_favorite_opponent
    assert_equal "DC United", @stat_tracker.favorite_opponent("18")
  end

  def test_it_has_a_rival
    assert_equal "LA Galaxy", @stat_tracker.rival("18")
  end

  # ************* Season Statistics *************

  def test_winningest_coach
    assert_equal "Claude Julien", @stat_tracker.winningest_coach(game_ids)
    assert_equal "Alain Vigneault", @stat_tracker.winningest_coach(game_ids)
  end

  def test_worst_coach
    assert_equal "Ted Nolan", @stat_tracker.worst_coach("20142015")
    assert_equal "Peter Laviolette", @stat_tracker.worst_coach("20132014")
  end

  #************Game Statistics *********************
  def test_highest_total_score
    assert_equal 11, @stat_tracker.highest_total_score
  end

  def test_lowest_total_score
    assert_equal 0, @stat_tracker.lowest_total_score
  end

  def test_percentage_home_wins
    assert_equal 0.44, @stat_tracker.percentage_home_wins
  end

  def test_percentage_visitor_wins
    assert_equal 0.36, @stat_tracker.percentage_visitor_wins
  end

  def test_percentage_ties
    assert_equal 0.20, @stat_tracker.percentage_ties
  end

  def test_count_of_games_by_season
    expected = {"20122013"=>806,
      "20162017"=>1317,
      "20142015"=>1319,
      "20152016"=>1321,
      "20132014"=>1323,
      "20172018"=>1355}
    assert_equal expected, @stat_tracker.count_of_games_by_season
  end

  def test_average_goals_per_game
    assert_equal 4.22, @stat_tracker.average_goals_per_game
  end

  def test_average_goals_by_season
    expected = {"20122013"=>4.12,
      "20162017"=>4.23,
      "20142015"=>4.14,
      "20152016"=>4.16,
      "20132014"=>4.19,
      "20172018"=>4.44}
    assert_equal expected, @stat_tracker.average_goals_by_season
  end
end
