module TvHelper

	def aired_or_not airdate
		raw(' aired') if Time.parse(airdate) < Time.now
	end
	
	def options show_name
		raw(
			content_tag(:span, class: 'options') do
				link_to('Edit', '#', class: 'edit-show', title: 'Edit Show') +
				link_to('Pirate Bay', "http://thepiratebay.se/search/#{show_name}", class: 'p-bay', target: '_blank', title: 'Pirate Bay Search')
			end
		)
	end

end