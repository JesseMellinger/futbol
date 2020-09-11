class GameTeamsManager

  def initialize(data, tracker)
    @game_teams = []
    @tracker = tracker
    create_game_teams(data)
  end

  def create_game_teams(data)
    game_teams_data = CSV.load(data)
    @game_teams = game_teams_data.map do |data|
      GameTeam.new(data, self)
    end
  end

end
