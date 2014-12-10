class AppDataController < ActionController::Base

  def update
    respond_to do |format|
      if AppData.update_download_link(params[:download_link])
        format.json { render json: {}, status: 200 }
      else
        format.json { render json: { message: 'An error occurred updating app data' }, status: :unprocessable_entity }
      end
    end
  end

end
