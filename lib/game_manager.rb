class GameManager

  def initialize(data, tracker)
    @games = []
    @tracker = tracker
    create_games(data)
  end

  def create_games(data)
    game_data = CSV.load(data)
    @games = game_data.map do |data|
      Game.new(data, self)
    end
  end

end
