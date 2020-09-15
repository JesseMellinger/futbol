module Findable

  def find_all_home_or_away_games(data, hoa)
    @game_teams.find_all do |game_team|
      game_team.hoa == hoa
    end
  end

  def find_games_by_team(data, team_id)
    @game_teams.find_all do |game_team|
      game_team.team_id == team_id
    end
  end
end
