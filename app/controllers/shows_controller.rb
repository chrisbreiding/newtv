class ShowsController < ActionController::Base
  layout 'application'

  def index
    @upcoming = Show.upcoming
    @recent = Show.recent
    @off_air = Show.off_air
    @last_updated = AppData.last_updated.to_s
  end

  def show
    @episodes = Show.find(params[:id]).episodes_by_season

    respond_to do |format|
      format.html
      format.json { render json: @episodes }
    end
  end

  def create
    require 'tvsource'

    @show = Show.where('tvsource_id = ?', params[:show][:tvsource_id]).first || Show.new(params[:show])

    respond_to do |format|
      if @show.save
        TvSource.update_episodes_for_show @show
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
        format.html { redirect_to @show }
        format.json { render json: @show }
      else
        format.html { render :edit }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @show = Show.find(params[:id])

    respond_to do |format|
      if @show.destroy
        format.html { redirect_to @show }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  def search
    @shows = Show.search(params[:name])

    respond_to do |format|
      format.html
      format.json { render json: @shows }
    end
  end

end
