module TvHelper

  def episode_status_class airdate
    if airdate == Date.today
      ' airs-today'
    elsif airdate > 2.months.from_now.to_date
      ' far-future'
    end
  end

  def format_timestamp timestamp
    date_time = DateTime.strptime(timestamp, '%s')
    date_time.strftime("%b %e, %Y %l:%M%P")
  end

end
