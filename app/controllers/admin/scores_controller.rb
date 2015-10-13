class Admin::ScoresController < AdminController
  before_action :set_score, only: [:show, :edit, :update, :destroy]

  # GET /admin/scores
  # GET /admin/scores.json
  def index
    if params[:field].present? && params[:keyword].present?
      @scores = Score.all.where(["#{params[:field]} like ?", "%#{params[:keyword]}%"]).page(params[:page]).per(params[:per])
    else
      @scores = Score.all.page(params[:page]).per(params[:per])
    end

  end

  # GET /admin/scores/1
  # GET /admin/scores/1.json
  def show
  end

  # GET /admin/scores/new
  def new
    # @competition_id = params[]
    @score = Score.new
  end

  def get_teams
    result = Team.where(competition_id: params[:competition_id]).select(:id, :name)
    render json: result
  end


  # GET /admin/scores/1/edit
  def edit
  end

  # POST /admin/scores
  # POST /admin/scores.json
  def create
    @score = Score.new(score_params)

    respond_to do |format|
      if @score.save
        format.html { redirect_to [:admin, @score], notice: '成绩添加成功' }
        format.json { render action: 'show', status: :created, location: @score }
      else
        format.html { render action: 'new' }
        format.json { render json: @score.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/scores/1
  # PATCH/PUT /admin/scores/1.json
  def update
    respond_to do |format|
      if @score.update(score_params)
        format.html { redirect_to [:admin, @score], notice: '成绩更新成功' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @score.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/scores/1
  # DELETE /admin/scores/1.json
  def destroy
    @score.destroy
    respond_to do |format|
      format.html { redirect_to admin_scores_url, notice: '成绩删除成功' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_score
    @score = Score.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def score_params
    params.require(:score).permit(:competition_id, :comp_name, :kind, :th, :team1_id, :team2_id, :score1, :score2, :referee_id, :operator)
  end
end
