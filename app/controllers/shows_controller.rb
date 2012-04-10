class ShowsController < ActionController::Base
	
	layout 'application'
	
	def index
		@shows = Show.includes(:episodes).where('episodes.airdate > ?', 3.days.ago )
		
		@off_air = Show.all.keep_if do |show|
			@shows.select { |s| s.name == show.name }.empty?
		end
	end
	
	def create
		@show = Show.new(params[:show])
		
		respond_to do |format|
			if @show.save
				format.html { redirect_to @show }
				format.json { render json: @show, status: :created, location: @show }
			else
				format.html { render :new }
				format.json { render json: @show.errors, status: :unprocessable_entity }
			end
		end
	end
	
	def update
		@show = Show.find(params[:id])
	
		respond_to do |format|
			if @show.update_attributes({ name: params[:name] })
				format.html  { redirect_to @show }
				format.json  { head :no_content }
			else
				format.html  { render :edit }
				format.json  { render json: @show.errors, status: :unprocessable_entity }
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