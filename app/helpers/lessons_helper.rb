module LessonsHelper
  def wday_number(day)
    case day.downcase
    when "sunday"
      return 0
    when "monday"
      return 1
    when "tuesday"
      return 2
    when "wednesday"
      return 3
    when "thursday"
      return 4
    when "friday"
      return 5
    when "saturday"
      return 6
    end
  end

  def get_start_time(day, time, start_time=Time.now.utc)
    wday = wday_number(day)
    if (start_time.wday != wday || start_time.strftime("%H:%M") >= time) 
      start_time = start_time.beginning_of_day
      start_time += 1.day
      until start_time.wday == wday
        start_time += 1.day
      end
    end

    until start_time.strftime("%H:%M") == time
      start_time += 1.minute
    end

    start_time
  end

  def beginning_of_week
    today = Time.now.utc.beginning_of_day
    until today.wday == 0
      today -= 1.day
    end
    today
  end
end
