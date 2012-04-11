class ChangeEpisodeNumberToString < ActiveRecord::Migration
	def up
		change_column :episodes, :episode_number, :string
	end
	
	def down
		change_column :episodes, :episode_number, :integer
	end
end