require "date.rb"

class PlanChart
  unloadable

  include Redmine::I18n

  attr_reader :weeks, :ticks, :data, :series, :start_date, :end_date,
    :max, :limit, :width, :height, :tick_interval

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

  def generate_user_chart(user, start_date, weeks)
    setup_chart start_date, weeks
    @limit = 100
    @max = 120
    @height = 300
    @tick_interval = 20

    series_hash = {}
    details = PlanDetail.user_details(user, plan_week(@start_date), plan_week(@end_date))
    details.each do |detail|
      series_hash[detail.request_id] ||= Array.new(weeks, 0)

      series_hash[detail.request_id][@week_idx[detail.week]] = detail.percentage
    end

    requests = series_hash.keys.sort
    @data = Array.new(requests.length)
    @series = Array.new(requests.length)
    requests.each_with_index do |req, i|
      data[i] = series_hash[req]
      request = PlanRequest.find(req, :include => :task)
      @series[i] = {}
      @series[i][:label] = l(:label_planner_request_short) + " #" + req.to_s + ": " + request.task.name
      @series[i][:color] = get_color i
    end

    check_empty
  end

  def generate_group_chart(group, start_date, weeks)
    setup_chart start_date, weeks
    @tick_interval = 50
    @limit = group.users.length * 100
    @max = @limit + @tick_interval
    @height = (@max * 0.7).to_i + 73

    series_hash = {}
    details = PlanDetail.group_overview(group, plan_week(@start_date), plan_week(@end_date))
    details.each do |detail|
      series_hash[detail.resource_id] ||= Array.new(weeks, 0)

      series_hash[detail.resource_id][@week_idx[detail.week]] = detail.percentage
    end

    resources = series_hash.keys.sort
    @data = Array.new(resources.length)
    @series = Array.new(resources.length)
    resources.each_with_index do |res, i|
      data[i] = series_hash[res]
      resource = User.find(res)
      @series[i] = {}
      @series[i][:label] = resource.name
      @series[i][:color] = get_color i
    end

    check_empty
  end

private

  def normalize_date(date)
    Date.commercial(date.cwyear, date.cweek, 1)
  end

  def plan_week(date)
    date.cwyear * 100 + date.cweek
  end

  def setup_chart(start_date, weeks)
    @weeks = weeks
    @start_date = normalize_date start_date
    @end_date = @start_date + 7 * (weeks - 1)

    @ticks = []
    @week_idx = {}
    tmp_date = @start_date.dup
    weeks.times do |i|
      @ticks.push tmp_date.cwyear.to_s + "-" + tmp_date.cweek.to_s
      @week_idx[plan_week tmp_date] = i
      tmp_date += 7
    end

    @width = @weeks * 53  + 66
  end

  def check_empty
    unless @data.any?
      @data.push Array.new(weeks, 0)
    end
  end

  def get_color(i)
    COLORS[i % COLORS.length]
  end
end
