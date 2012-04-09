class Show < ActiveRecord::Base
	validates_presence_of :name, :tvrage_id
end