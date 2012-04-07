module TvHelper

	def aired_or_not airdate
		raw(' class="aired"') if Time.parse(airdate) < Time.now
	end
	
	def pirate_link show_name
		raw(
			content_tag(:span, class: 'p-bay') do
				link_to 'Pirate Bay', "http://thepiratebay.se/search/#{show_name}", target: '_blank'
			end
		)
	end

end