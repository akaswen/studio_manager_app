module TimeSlotsHelper
  def next_date_on_day_with_time(wday, time)
    currentTime = DateTime.now.utc.beginning_of_day
    until currentTime.wday == wday
      currentTime += 1.day
    end
    until currentTime.strftime("%H:%M") == time
      currentTime += 15.minutes
    end
    currentTime
  end
end
