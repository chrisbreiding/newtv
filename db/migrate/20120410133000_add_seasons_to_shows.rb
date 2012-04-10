class AddSeasonsToShows < ActiveRecord::Migration
	def change
		add_column :shows, :seasons, :integer
	end
end