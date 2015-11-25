class Admin::CreativeActivitiesController < AdminController
  before_action :set_creative_activity, only: [:show, :edit, :update, :destroy]
  before_action do
    authenticate_permissions(['super_admin','admin','editor','audit'])
  end


  def index
    if params[:field].present? && params[:keyword].present?
      @activities = CreativeActivity.all.where(["#{params[:field]} like ?", "%#{params[:keyword]}%"]).per_page_kaminari(params[:page]).per(params[:per])
    else
      @activities = CreativeActivity.all.per_page_kaminari(params[:page]).per(params[:per])
    end
  end


  def show
  end

  def new
    @activity = CreativeActivity.new
  end

  def edit
  end


  def create
    @activity = CreativeActivity.new(creative_activity_params)

    respond_to do |format|
      if @activity.save
        format.html { redirect_to [:admin, @activity], notice: '作品创建成功.' }
        format.json { render action: 'show', status: :created, location: @activity }
      else
        format.html { render action: 'new' }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @activity.update(creative_activity_params)
        format.html { redirect_to [:admin, @activity], notice: '作品更新成功.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @activity.destroy
    respond_to do |format|
      format.html { redirect_to admin_creative_activities_url, notice: '作品删除成功.' }
      format.json { head :no_content }
    end
  end

  def add_expert_score
    activity = CreativeActivity.find(params[:activity_id])
    activity.expert_score = params[:expert_score]
    activity.last_score = (activity.expert_score.to_f + activity.likes_count).to_s
    if activity.save
      result = [true, '评分成功']
    else
      result = [false, '评分过程出现意外']
    end
    render json: result
  end

  def edit_expert_score
    activity = CreativeActivity.find(params[:activity_id])
    activity.expert_score = params[:expert_score]
    activity.last_score = (activity.expert_score.to_f + activity.likes_count).to_s
    if activity.save
      result = [true, '评分更改成功']
    else
      result = [false, '评分修改过程出现意外']
    end
    render json: result
  end


  def audit
    if request.method == 'POST'
      activity = CreativeActivity.find(params[:activity_id])
      activity.is_audit = params[:status].to_i
      if activity.save
        result = [true, '操作成功!']
      else
        result = [true, '操作失败!']
      end
      render json: result
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_creative_activity
    @activity = CreativeActivity.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def creative_activity_params
    params.require(:creative_activity).permit!
  end
end
