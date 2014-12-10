class AddDownloadLinkToAppData < ActiveRecord::Migration
  def change
    add_column :app_data, :download_link, :string
  end
end
