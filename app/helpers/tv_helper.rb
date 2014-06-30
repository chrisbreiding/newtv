module TvHelper

  def epnum_short season, episode_number
    season.to_s + episode_number
  end

  def epnum_long season, episode_number
    season_string = season.to_s
    if season_string.length < 2
      season_string = "0#{season_string}"
    end

    "s#{season_string}e#{episode_number}"
  end

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
