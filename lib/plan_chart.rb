require "date.rb"

class PlanChart
  unloadable

  include Redmine::I18n

  attr_reader :weeks, :ticks, :week_ticks, :data, :series, :series_details, :start_date, :end_date,
    :max, :width, :height, :tick_interval, :threshold_data, :threshold_series, :calc

  # d3_category20
  #COLORS = [
  #  "#1f77b4", "#aec7e8", "#ff7f0e", "#ffbb78", "#2ca02c", "#98df8a", "#d62728",
  #  "#ff9896", "#9467bd", "#c5b0d5", "#8c564b", "#c49c94", "#e377c2", "#f7b6d2",
  #  "#7f7f7f", "#c7c7c7", "#bcbd22", "#dbdb8d", "#17becf", "#9edae5" ];

  # d3_category20b
  #COLORS = [
  #  "#393b79", "#5254a3", "#6b6ecf", "#9c9ede", "#637939", "#8ca252", "#b5cf6b",
  #  "#cedb9c", "#8c6d31", "#bd9e39", "#e7ba52", "#e7cb94", "#843c39", "#ad494a",
  #  "#d6616b", "#e7969c", "#7b4173", "#a55194", "#ce6dbd", "#de9ed6" ];

  # d3_category20c
  COLORS = [
    "#3182bd", "#6baed6", "#9ecae1", "#c6dbef", "#e6550d", "#fd8d3c", "#fdae6b",
    "#fdd0a2", "#31a354", "#74c476", "#a1d99b", "#c7e9c0", "#756bb1", "#9e9ac8",
    "#bcbddc", "#dadaeb", "#636363", "#969696", "#bdbdbd", "#d9d9d9" ];

  def initialize(project, start_date, weeks)
    @calc = PlanCalc.new(project)
    weeks ||= @calc.config[:graph_weeks].to_i
    weeks = 52 if (weeks > 52)
    start_date ||= Date.today - (7 * @calc.config[:graph_weeks_past].to_i)

    @weeks = weeks
    @start_date = PlanCalc.normalize_date start_date
    @end_date = @start_date + 7 * (weeks - 1)

    @ticks = []
    @week_ticks = []
    @week_idx = {}
    tmp_date = @start_date.dup
    weeks.times do |i|
      @ticks.push format_date tmp_date
      @week_ticks.push 'W' + ("%02d" % tmp_date.cweek)
      @week_idx[PlanDetail.plan_week tmp_date] = i
      tmp_date += 7
    end
  end

  def generate_user_chart(user, states)
    @tick_interval = 20

    details = PlanDetail.user_details(user, states, @start_date, @end_date)
    process_request_chart(details)
  end

  def generate_group_chart(group, states)
    @tick_interval = 50
    @calc.scale = group.users.length

    series_hash = {}
    details = PlanDetail.group_overview(group, states, @start_date, @end_date)
    details.each do |detail|
      series_hash[detail.resource_id.to_s] ||= week_array
      series_hash[detail.resource_id.to_s][@week_idx[detail.week]] = detail.percentage
    end

    resources = group.users.sort
    @data = Array.new(series_hash.length)
    @series = Array.new(series_hash.length)
    @series_details = Array.new(series_hash.length)
    resources.each_with_index do |res, i|
      data[i] = series_hash[res.id.to_s] || week_array
      @series_details[i] = res
      @series[i] = {}
      @series[i][:color] = get_color i
    end

    finalize_chart
  end

  def generate_task_chart(task, states)
    @calc.scale = 0
    @tick_interval = 40

    details = PlanDetail.task_details(task, states, @start_date, @end_date)
    process_request_chart(details)
  end

  def get_color(i)
    COLORS[i % COLORS.length]
  end

private

  def week_array
    Array.new(@weeks, 0)
  end

  def process_request_chart(details)
    series_hash = {}
    details.each do |detail|
      series_hash[detail.request_id] ||= week_array
      series_hash[detail.request_id][@week_idx[detail.week]] = detail.percentage
    end

    requests = series_hash.keys.sort
    @data = Array.new(requests.length)
    @series = Array.new(requests.length)
    @series_details = Array.new(requests.length)
    requests.each_with_index do |req, i|
      data[i] = series_hash[req]
      @series_details[i] = PlanRequest.find(req, :include => :task)
      @series[i] = {}
      @series[i][:color] = get_color i
    end

    finalize_chart
  end

  def finalize_chart
    @data.push Array.new(@weeks, 0) unless @data.any?

    # 0: overload, 1: ok, 2: not enough, see PlanCalc
    @threshold_series = [ {:color => "#d62728"}, {:color => "#2ca02c"}, {:color => "gold"} ]
    @threshold_data = [ week_array, week_array, week_array ]
    sets = @data.length

    max = 0
    @weeks.times do |i|
      sum = 0
      sets.times do |j|
        sum += @data[j][i]
      end

      max = sum if sum > max;

      idx = i + 1;
      @threshold_data[0][i] = [idx, 0, 0]
      @threshold_data[1][i] = [idx, 0, 0]
      @threshold_data[2][i] = [idx, 0, 0]

      @threshold_data[@calc.workload_class(sum)][i] = [idx, 1, sum]
    end

    target = @calc.work_target
    @max = max % @tick_interval == 0 ? max : max + @tick_interval - (max % @tick_interval)
    @max = target + @tick_interval if target > 0 && @max < target + @tick_interval
    @height = (@max * 35 / @tick_interval).to_i + 73
    @width = @weeks * 53 + 66
  end
end
