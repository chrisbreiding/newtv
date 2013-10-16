class ChangeTvsourceToAppData < ActiveRecord::Migration
  def change
    rename_table :tvsource, :app_data
  end
end
