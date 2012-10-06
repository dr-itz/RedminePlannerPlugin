require "date.rb"

class PlanChart
  unloadable

  def generate_user_chart(user, start_date, weeks)
    @ticks = []
    week_idx = {}
    tmp_date = start_date.dup
    for i in 1..weeks
      @ticks.push tmp_date.cwyear.to_s + "-" + tmp_date.cweek.to_s
      week_idx[tmp_date.cwyear * 100 + tmp_date.cweek] = i - 1
      tmp_date += 7
    end

    end_date = start_date + 7 * (weeks - 1)
    start_week = start_date.cwyear * 100 + start_date.cweek
    end_week = end_date.cwyear * 100 + end_date.cweek

    series_hash = {}
    details = PlanDetail.user_details(user, start_week, end_week)
    details.each do |detail|
      unless series_hash[detail.request_id]
        series = Array.new(weeks)
        series.fill(0)
        series_hash[detail.request_id] = series
      else
        series = series_hash[detail.request_id]
      end

      idx = week_idx[detail.week]
      series[idx] = detail.percentage
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

  def ticks
    @ticks
  end

  def data
    @data
  end

  def series
    @series
  end
end
