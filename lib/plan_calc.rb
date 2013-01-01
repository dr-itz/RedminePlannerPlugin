class PlanCalc
  unloadable

  attr_reader :config, :scale, :work_target, :work_ths_over, :work_ths_ok

  WORKLOAD_CLASS_OVER = 0
  WORKLOAD_CLASS_OK   = 1
  WORKLOAD_CLASS_FREE = 2

  WORKLOAD_CLASS_COLORS = [ "#d62728", "#2ca02c", "gold" ]
  WORKLOAD_CLASS_FONT_COLORS = [ "white", "white", "black" ]

  def self.normalize_date(date)
    Date.commercial(date.cwyear, date.cweek, 1)
  end

  def initialize(project)
    @config = PlanConfig.project_config(project)
    self.scale = 1
    @states = [ PlanRequest::STATUS_APPROVED, PlanRequest::STATUS_READY ]
  end

  def scale=(val)
    @scale = val

    @work_target   = @scale * @config[:workload_target].to_i
    @work_ths_over = @scale * @config[:workload_threshold_overload].to_i
    @work_ths_ok   = @scale * @config[:workload_threshold_ok].to_i
  end

  def workload_class(workload)
    if @work_ths_over > 0 && workload > @work_ths_over
      return WORKLOAD_CLASS_OVER
    elsif workload >= @work_ths_ok
      return WORKLOAD_CLASS_OK
    end
    return WORKLOAD_CLASS_FREE
  end

  def workload_color(workload)
    clazz = workload_class(workload)
    "background-color: " + WORKLOAD_CLASS_COLORS[clazz] +
      ";color: " + WORKLOAD_CLASS_FONT_COLORS[clazz] + ";"
  end

  def prepare_user_req_workload(req)
    @weekly_load = {}
    list = PlanDetail.user_req_workload(req, @states)
    list.each do |det|
      @weekly_load[det.week] = det.percentage
    end
  end

  def weekly_load(week)
    @weekly_load[week]
  end
end
