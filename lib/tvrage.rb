module TvRage

	def self.sync(new_show = nil)
		require 'open-uri'

#		Episode.delete_all if new_show.nil?
		
		shows = new_show ? [new_show] : Show.all

 		shows.each do |show|
 			url = "http://services.tvrage.com/feeds/episode_list.php?sid=#{show[:tvrage_id]}"
			xml = Nokogiri::XML(open(url))
			
			# update show with latest season
			latest_season = xml.xpath('//totalseasons').text
			show.update_attributes seasons: latest_season
			
			# add all the episodes
			xml.xpath('//Season').each do |season|
				season_no = season.get_attribute('no').to_i
				
				season.children.each do |episode|
					
					details = {}
					
					episode.children.each do |detail|
						details[detail.name] = detail.text
					end
					
					Episode.create(
						show_id:		show[:id],
						season: 		season_no,
						episode_number: details['seasonnum'],
						title: 			details['title'],
						airdate: 		details['airdate']
					) unless details['title'].nil?
				end
			end
		end	
	end 
	
end