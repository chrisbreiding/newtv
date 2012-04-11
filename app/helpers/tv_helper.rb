module TvHelper

	def aired_or_not airdate
		raw(' aired') if Time.parse(airdate) < 1.day.ago
	end
	
	def options show_name
		raw(
			content_tag(:span, class: 'options') do
				link_to('Edit', '#', class: 'edit-show', title: 'Edit Show') +
				link_to('Pirate Bay', "http://thepiratebay.se/search/#{show_name}", class: 'p-bay', target: '_blank', title: 'Pirate Bay Search')
			end
		)
	end
	
	def epnum episode
		episode.season.to_s + pad(episode.episode_number)
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