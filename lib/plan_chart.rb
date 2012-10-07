require "date.rb"

class PlanChart
  unloadable

  attr_reader :weeks, :ticks, :data, :series, :start_date, :end_date

  def generate_user_chart(user, start_date, weeks)
    setup_chart start_date, weeks

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
      @series[i][:label] = "#" + req.to_s + ": " + request.task.name
    end

    check_empty
  end

private
  def normalize_date(date)
    Date.commercial(date.cwyear, date.cweek)
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
    for i in 1..weeks
      @ticks.push tmp_date.cwyear.to_s + "-" + tmp_date.cweek.to_s
      @week_idx[plan_week tmp_date] = i - 1
      tmp_date += 7
    end
  end

  def check_empty
    unless @data.any?
      @data.push Array.new(weeks, 0)
    end
  end
end
