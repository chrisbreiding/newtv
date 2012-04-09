class ShowsController < ActionController::Base
	
	layout 'application'
	
	def index
		require 'open-uri'
		
# 		shows = { 
# 			'Modern Family' 		=> '22622',
# 			'New Girl' 				=> '28304',
# 			'Game of Thrones' 		=> '24493',
# 			'30 Rock' 				=> '11215',
# 			'The Office' 			=> '6061',
# 			'Boardwalk Empire' 		=> '23561',
# 			'Curb Your Enthusiasm' 	=> '3188'
# 		}

		shows = Show.all
		
		@shows = []
		@off_air = []

 		shows.each do |show|
			
 			url = "http://services.tvrage.com/feeds/episode_list.php?sid=#{show[:tvrage_id]}"
			
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
							name: show[:name], 
							season: latest_season, 
							next_episode: episodes[0]['airdate'],
							episodes: episodes 
						}
						
					end
				
				end
				
			end
		
			if @shows.select { |s| s[:name] == show[:name] }.empty?
			
				@off_air << { name: show[:name] }
			
			end
				
		end
		
		@shows.sort! do |a,b|
			
			a[:next_episode] <=> b[:next_episode]
			
		end
				
		respond_to do |format|
			format.html
		end
				
	end
	
	def create
		@show = Show.new(params[:show])
		
		respond_to do |format|
			
			if @show.save
				format.html { redirect_to @show }
				format.json { render json: @show, status: created, location: @show }
			else
				format.html { render action: 'new' }
				format.json { render json: @show.errors, status: :unprocessable_entity }
			end
			
		end
	end
	
	def search
		
		require 'uri'
		
		show_name = params[:name]
		
		uri_safe = URI.escape show_name

		url = "http://services.tvrage.com/feeds/search.php?show=#{uri_safe}"
		
		xml = Nokogiri::XML(open(url))

		tags = %w{showid country name started seasons classification}
				
		@results = []
		
		xml.xpath('//show').each do |show|
						
			details = {}
			
			show.children.each do |detail|
				
				if tags.index detail.name
					details[detail.name] = detail.text
				end
				
			end
			
			@results << details
			
		end
		
		respond_to do |format|
			format.html
			format.json { render json: @results }
		end
				
	end
	
end