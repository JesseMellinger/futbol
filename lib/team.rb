class Team

  def initialize(row, manager)
    @team_id = row[:team_id]
    @franchiseId = row[:franchiseId]
    @teamName = row[:teamName]
    @abbreviation = row[:abbreviation]
    @link = row[:link]
    @manager = manager
  end

end
