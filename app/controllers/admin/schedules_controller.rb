class Admin::SchedulesController < AdminController
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]

  # GET /admin/schedules
  # GET /admin/schedules.json
  def index
    @schedules = Schedule.all.per_page_kaminari(params[:page]).per(params[:per])
  end

  # GET /admin/schedules/1
  # GET /admin/schedules/1.json
  def show
  end

  # GET /admin/schedules/new
  def new
    @schedule = Schedule.new
  end

  # GET /admin/schedules/1/edit
  def edit
  end

  # POST /admin/schedules
  # POST /admin/schedules.json
  def create
    @schedule = Schedule.new(schedule_params)

    respond_to do |format|
      if @schedule.save
        format.html { redirect_to [:admin, @schedule], notice: '赛程创建成功' }
        format.json { render action: 'show', status: :created, location: @schedule }
      else
        format.html { render action: 'new' }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/schedules/1
  # PATCH/PUT /admin/schedules/1.json
  def update
    respond_to do |format|
      if @schedule.update(schedule_params)
        format.html { redirect_to [:admin, @schedule], notice: '赛程更新成功' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/schedules/1
  # DELETE /admin/schedules/1.json
  def destroy
    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to admin_schedules_url, notice: '赛程删除成功' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_schedule
    @schedule = Schedule.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def schedule_params
    params.require(:schedule).permit(:name)
  end
end
