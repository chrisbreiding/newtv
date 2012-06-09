module TvHelper

  def flash_notice notice, type
      raw(
        content_tag(:div, id: 'notice', class: "notice clearfix #{type}") do
          content_tag(:p, notice) +
          link_to('Close notice', '#', id: 'close-notice', class: 'close-notice')
        end
      )
  end

	def options show
		raw(
			content_tag(:span, class: 'options') do
				link_to('Show All Episodes', show_path(show), class: 'show-all-episodes', title: 'Show All Episodes') +
				link_to('Edit', edit_show_path(show), class: 'edit-show', title: 'Edit Show') +
				link_to('Pirate Bay', "http://thepiratebay.se/search/#{show.name}", class: 'p-bay', target: '_blank', title: 'Pirate Bay Search')
			end
		)
	end

  def episode_status_class airdate
    today = Date.today
    if airdate == today
      ' airs-today'
    elsif airdate < today
      ' aired'
    elsif airdate > 2.months.from_now.to_date
      ' far-future'
    end
  end

end