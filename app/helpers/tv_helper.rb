module TvHelper

  def flash_notice notice, type
    content = content_tag(:div, id: 'notice', class: "notice clearfix #{type}") do
      notice_text = content_tag :p, content_tag(:span, nil, class: 'notice-dot') + notice
      close_link = link_to('Close notice', '#', id: 'close-notice', class: 'close-notice')

      notice_text + close_link
    end

    raw content
  end

	def options show
		content = content_tag(:span, class: 'options') do
			all = link_to('Show All Episodes', show_path(show), class: 'show-all-episodes', title: 'Show All Episodes')
			edit = link_to('Edit', edit_show_path(show), class: 'edit-show', title: 'Edit Show')
			pb = link_to('Pirate Bay', "http://thepiratebay.se/search/#{show.name}", class: 'p-bay', target: '_blank', title: 'Pirate Bay Search')

      all + edit + pb
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
