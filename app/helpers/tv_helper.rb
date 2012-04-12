module TvHelper

	def episode_status airdate
		if Time.now.strftime("%Y-%m-%d") == airdate
			raw(' airs-today')
		elsif Time.parse(airdate) < 1.day.ago
			raw(' aired')
		elsif Time.parse(airdate) > 2.months.from_now
			raw(' far-future')
		end
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
	
	def epnum episode
		episode.season.to_s + episode.episode_number
	end
	
	def pad num
		if num < 10
			num = '0' + num.to_s
		else 
			num = num.to_s
		end
		num
	end
end