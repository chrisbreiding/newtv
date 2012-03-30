class TvController < ActionController::Base
	
	def initialize
	end
	
	def index
		require 'open-uri'
		
		ids = { 
			'New Girl' => '28304',
			'Modern Family' => '22622',
			'The Office' => '6061'
		}
		
# 		@episodes = []
# 		
# 		url = "http://services.tvrage.com/feeds/episode_list.php?sid=28304"
# 		
# 		xml = Nokogiri::XML(open(url))
# 		
# 		xml.xpath('//episode/title').each do |title|
# 			@episodes.push title.text
# 		end		
		
		@shows = []
		
		ids.each do |name, id|
		
			episodes = []
					
			url = "http://services.tvrage.com/feeds/episode_list.php?sid=#{id}"
			
			xml = Nokogiri::XML(open(url))
			
			xml.xpath('//episode/title').each do |title|
				episodes.push title.text
			end

			@shows.push( { name: name, episodes: episodes } )
			
		end
				
	end

end