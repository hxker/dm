class HomeController < ApplicationController
  def index
    @competition = Competition.last
    @events = Event.where(competition_id: @competition.id)
  end
end
