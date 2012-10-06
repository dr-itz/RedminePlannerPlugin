require "date.rb"

class PlanChart
  unloadable

  def generate_user_chart(user, start_date, weeks)
    setup_chart start_date, weeks

    series_hash = {}
    details = PlanDetail.user_details(user, plan_week(@start_date), plan_week(@end_date))
    details.each do |detail|
      unless series_hash[detail.request_id]
        series = Array.new(weeks)
        series.fill(0)
        series_hash[detail.request_id] = series
      else
        series = series_hash[detail.request_id]
      end

      series[@week_idx[detail.week]] = detail.percentage
    end

    requests = series_hash.keys
    i = 0
    @data = Array.new(requests.length)
    @series = Array.new(requests.length)
    requests.each do |req|
      data[i] = series_hash[req]
      request = PlanRequest.find(req, :include => :task)
      @series[i] = {}
      @series[i][:label] = "#" + req.to_s + ": " + request.task.name
      i += 1
    end
  end

  def weeks
    @weeks
  end

  def ticks
    @ticks
  end

  def data
    @data
  end

  def series
    @series
  end

  def start_date
    @start_date
  end

  def end_date
    @end_date
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
end
