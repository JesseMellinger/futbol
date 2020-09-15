module Findable

  def find_all_home_or_away_games(data, hoa)
    data.find_all do |object|
      object.hoa == hoa
    end
  end

  def find_games_by_team(data, team_id)
    data.find_all do |object|
      object.team_id == team_id
    end
  end

  def find_season_by_game_ids(data, game_ids)
    data.find_all do |game|
      game_ids.include?(game.game_id)
    end
  end
end
