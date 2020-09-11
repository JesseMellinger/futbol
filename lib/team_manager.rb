require 'csv'
require './lib/team'

class TeamManager

  def initialize(data, tracker)
    @teams = []
    @tracker = tracker
    create_teams(data)
  end

  def create_teams(data)
    @teams = data.map do |data|
      Team.new(data, self)
    end
  end

end
