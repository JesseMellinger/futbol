class GameTeam

  def initialize(row, manager)
    @game_id = row[:game_id]
    @team_id = row[:team_id]
    @hoa = row[:HoA]
    @result = row[:result]
    @head_coach = row[:head_coach]
    @goals = row[:goals]
    @shots = row[:shots]
    @tackles = row[:tackles]
    @manager = manager
  end

end
