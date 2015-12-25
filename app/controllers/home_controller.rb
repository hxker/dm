class HomeController < ApplicationController
  def index
    @competition = Competition.last
    if @competition.present?
      @events = Event.where(competition_id: @competition.id)
    end
  end
end
