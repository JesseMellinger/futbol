class Team
  attr_reader :team_id, :franchise_id, :team_name, :abbreviation, :link,
              :manager

  def initialize(row, manager)
    @team_id = row[:team_id]
    @franchise_id = row[:franchiseid]
    @team_name = row[:teamname]
    @abbreviation = row[:abbreviation]
    @link = row[:link]
    @manager = manager
  end

  def team_info
    { "team_id" => team_id,
      "franchise_id" => franchise_id,
      "team_name" => team_name,
      "abbreviation" => abbreviation,
      "link" => link }
  end

  def best_season
    seasons_by_win_percentage.max_by do |season, win_percentage|
      win_percentage
    end.first
  end

  def worst_season
    seasons_by_win_percentage.min_by do |season, win_percentage|
      win_percentage
    end.first
  end

  def average_win_percentage
    manager.win_percentage(team_games)
  end

  def seasons_by_win_percentage
    seasons_by_win_percentage = {}
    games_by_season.each do |season, games|
      seasons_by_win_percentage[season] = manager.win_percentage(games)
    end
    seasons_by_win_percentage
  end

  def games_by_season
    team_games.group_by do |team_game|
      games.find do |game|
        team_game.game_id == game.game_id
      end.season
    end
  end

  def team_games
    @manager.tracker.game_team_manager.find_games_by_team(team_id)
  end

  def games
    @manager.tracker.game_manager.find_games_by_team(team_id)
  end

  def most_goals_scored
    team_games.max_by do |game|
      game.goals
    end.goals.to_i
  end

  def fewest_goals_scored
    team_games.min_by do |game|
      game.goals
    end.goals.to_i
  end

  def favorite_opponent
    opponent = opponents_by_win_percentage.min_by do |opponent, win_percentage|
      win_percentage
    end
    @manager.team_info(opponent.first)["team_name"]
  end

  def rival
    opponent = opponents_by_win_percentage.max_by do |opponent, win_percentage|
      win_percentage
    end
    @manager.team_info(opponent.first)["team_name"]
  end

  def opponents_by_win_percentage
    opponents_by_win_percentage = {}
    games_by_opponent.each do |opponent, games|
      opponents_by_win_percentage[opponent] = manager.win_percentage(games)
    end
    opponents_by_win_percentage
  end

  def games_by_opponent
    opponent_team_games.group_by do |game|
      game.team_id
    end
  end

  def opponent_team_games
    team_games.map do |game|
      game.opponent
    end
  end

end
