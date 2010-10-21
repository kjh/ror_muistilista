class Tag < ActiveRecord::Base
	belongs_to :user
	has_many :taggings, :dependent => :destroy
	has_many :tasks, :through => :taggings
end
