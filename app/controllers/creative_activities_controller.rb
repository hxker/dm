class CreativeActivitiesController < ApplicationController
  before_action :set_creative_activity, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit]
  # GET /creative_activities
  # GET /creative_activities.json
  def index
    @creative_activities = CreativeActivity.all.per_page_kaminari(params[:page]).per(params[:per])
  end

  # GET /creative_activities/1
  # GET /creative_activities/1.json
  def show
    if current_user.present?
      @user_likes = current_user.likes.pluck(:creative_activity_id)
    end
  end

  # GET /creative_activities/new
  def new
    @creative_activity = CreativeActivity.new
  end

  # GET /creative_activities/1/edit
  def edit
  end

  # POST /creative_activities
  # POST /creative_activities.json
  def create
    @creative_activity = CreativeActivity.new(creative_activity_params)

    respond_to do |format|
      if @creative_activity.save


        format.html { redirect_to @creative_activity, notice: '创意活动创建成功' }
        format.json { render :show, status: :created, location: @creative_activity }
      else
        format.html { render :new }
        format.json { render json: @creative_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /creative_activities/1
  # PATCH/PUT /creative_activities/1.json
  def update
    respond_to do |format|
      if @creative_activity.update(creative_activity_params)
        format.html { redirect_to @creative_activity, notice: '创意活动更新成功' }
        format.json { render :show, status: :ok, location: @creative_activity }
      else
        format.html { render :edit }
        format.json { render json: @creative_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /creative_activities/1
  # DELETE /creative_activities/1.json
  def destroy
    @creative_activity.destroy
    respond_to do |format|
      format.html { redirect_to creative_activities_url, notice: '创意活动删除成功' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_creative_activity
    @creative_activity = CreativeActivity.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def creative_activity_params
    params.require(:creative_activity).permit(:name, :cover, :file, :media, :description, :user_id)
  end
end
