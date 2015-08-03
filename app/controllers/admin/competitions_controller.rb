class Admin::CompetitionsController < AdminController
  before_action :set_competition, only: [:show, :edit, :update, :destroy]

  def index
    if params[:field].present? && params[:keyword].present?
      @competitions = Competition.all.where(["#{params[:field]} like ?", "%#{params[:keyword]}%"]).page(params[:page]).per(params[:per])
    else
      @competitions = Competition.all.page(params[:page]).per(1)
    end
  end

  def new
    @competition = Competition.new
  end

  def show
  end

  def edit
  end

  def create
    @competition = Competition.new(competition_params)
    respond_to do |format|
      if @competition.save
        format.html { redirect_to admin_competitions_path, notice: '新增赛事：【'+@competition.name+'】 成功' }
        format.json { render action: 'index', status: :created, location: @competition }
      else
        format.html { render action: 'new' }
        format.json { render json: @competition.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @competition.update(competition_params)
        format.html { redirect_to admin_competitions_path, notice: '修改赛事：【'+@competition.name+'】 成功' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @competition.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @competition.destroy
    respond_to do |format|
      format.html { redirect_to admin_competitions_url, notice: '删除赛事：【'+@competition.name+'】 成功' }
      format.json { head :no_content }
    end
  end

  private
  def set_competition
    @competition = Competition.find(params[:id])
  end

  def competition_params
    params.require(:competition).permit(:name, :desc, :organizers, :state, :sign_in_begin_time, :sign_in_end_time, :begin_time, :end_time)
  end
end

