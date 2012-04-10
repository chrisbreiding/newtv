class Show < ActiveRecord::Base
	validates_presence_of :name, :tvrage_id
	has_many :episodes, dependent: :destroy	
end