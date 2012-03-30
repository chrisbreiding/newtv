class TvController < ActionController::Base
	def index
		require 'open-uri'
	
		xml = Nokogiri::XML(open('http://services.tvrage.com/feeds/episode_list.php?sid=28304'))
		
		@episodes = xml.xpath('//episode/title').map do |title|
			title.text
		end
	end

end