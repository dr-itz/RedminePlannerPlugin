class PlanCalc
  unloadable

  attr_reader :config, :scale, :work_target, :work_ths_over, :work_ths_ok

  WORKLOAD_CLASS_OVER = 0
  WORKLOAD_CLASS_OK   = 1
  WORKLOAD_CLASS_FREE = 2

  def self.normalize_date(date)
    Date.commercial(date.cwyear, date.cweek, 1)
  end

  def initialize(project)
    @config = PlanConfig.project_config(project)
    self.scale = 1
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

end
