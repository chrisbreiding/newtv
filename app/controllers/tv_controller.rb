class TvController < ActionController::Base
	
	layout 'application'
	
	def index
		require 'open-uri'
		
		shows = { 
			'Modern Family' 		=> '22622',
			'New Girl' 				=> '28304',
			'Game of Thrones' 		=> '24493',
			'30 Rock' 				=> '11215',
			'The Office' 			=> '6061',
			'Boardwalk Empire' 		=> '23561',
			'Curb Your Enthusiasm' 	=> '3188'
		}
		
		@shows = []
		@off_air = []

 		shows.each do |name, id|
			
 			url = "http://services.tvrage.com/feeds/episode_list.php?sid=#{id}"
			
			xml = Nokogiri::XML(open(url))
	
			latest_season = xml.xpath('//totalseasons').text
			
			xml.xpath('//Season').each do |season|
				
				if season.get_attribute('no') == latest_season
				
					episodes = []
			
					season.children.each do |episode|
						
						details = {}
						
						episode.children.each do |detail|
							
							details[detail.name] = detail.text
							
						end
						
						date = details['airdate']
						
						if details['title'] && Time.parse(date) > 3.days.ago
							episodes << details
						end
						
					end
					
					unless episodes.empty?
						
						@shows << { 
							name: name, 
							season: latest_season, 
							next_episode: episodes[0]['airdate'],
							episodes: episodes 
						}
						
					end
				
				end
				
			end
		
			if @shows.select { |show| show[:name] == name }.empty?
			
				@off_air << { name: name }
			
			end
				
		end
		
		@shows.sort! do |a,b|
			
			a[:next_episode] <=> b[:next_episode]
			
		end
				
		respond_to do |format|
			format.html
		end
				
	end

end