class TeamManager

  def initialize(data, tracker)
    @teams = []
    @tracker = tracker
    create_teams(data)
  end

  def create_teams(data)
    team_data = CSV.load(data)
    @teams = team_data.map do |data|
      Team.new(data, self)
    end
  end

end
