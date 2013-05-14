module TvHelper

  def episode_status_class airdate
    if airdate == Date.today
      ' airs-today'
    elsif airdate > 2.months.from_now.to_date
      ' far-future'
    end
  end

end
