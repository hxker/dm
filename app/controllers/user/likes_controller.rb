class User::LikesController < ApplicationController
  before_action :authenticate

  # def index
  #   @favorites = current_user.likes.includes(:creative_activity).all
  #   @user_favorites = @favorites.pluck(:creative_activity_id)
  # end


  def create
    @creative_activity = CreativeActivity.find(params[:id])
    @status, @is_present = Like.toggle(current_user.id, @creative_activity.id)
    respond_to do |format|
      format.js
    end
  end
end
