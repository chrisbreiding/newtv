module TvHelper

  def flash_notice notice, type
    content = content_tag(:div, id: 'notice', class: "notice clearfix #{type}") do
      notice_text = content_tag :p, content_tag(:span, nil, class: 'notice-dot') + notice
      close_link = link_to('Close notice', '#', id: 'close-notice', class: 'close-notice')

      notice_text + close_link
    end

    raw content
  end

  def episode_status_class airdate
    if airdate == Date.today
      ' airs-today'
    elsif airdate > 2.months.from_now.to_date
      ' far-future'
    end
  end

end
