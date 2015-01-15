class SplitShowName < ActiveRecord::Migration
  def change
    rename_column :shows, :name, :display_name
    add_column :shows, :search_name, :text
    add_column :shows, :file_name, :text
  end
end
