module MemryTime
  extend self

  def memry_time_zone
    ActiveSupport::TimeZone.new("EST")
  end

  def now
    memry_time
  end

  def memry_time
    memry_time_zone.now
  end

  def to_db_s(datetime)
    at(datetime).utc.to_s(:db)
  end

  def at(datetime_utc)
    ActiveSupport::TimeWithZone(datetime_utc, memry_time_zone)
  end

  def beginning_of_day
    memry_time.beginning_of_day
  end

  def end_of_day
    memry_time.end_of_day
  end

  def today
    memry_time.to_date
  end

  def start_of_week(d = today)
    d.beginning_of_week
  end

  def start_of_month(d = today)
    m = first_monday(d)
    if m > d
      m = first_monday(d - 1.month)
    else
      m
    end
  end

  def start_of_previous_week(d = today)
    start_of_week(d - 1.week)
  end

  def start_of_previous_month(d = today)
    start_of_month(d - 1.month)
  end

  def seconds_remaining(target)
    (target - MemryTime.now).ceil
  end

  def end_of_month(d = today)
    d = start_of_month(d)
    e = d + 4.weeks
    e += 1.week while d.month == e.month
    e - 1.day

  end

  def first_monday(date = today)
    m = date.beginning_of_month
    if m.monday?
      m
    else
      m.next_week
    end
  end

  def last_sunday
    start_of_week - 1.day
  end
end