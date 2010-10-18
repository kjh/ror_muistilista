class Task < ActiveRecord::Base
	belongs_to :user
	has_many :taggings, :dependent => :destroy
	has_many :tags, :through => :taggings
	attr_protected :user_id
	attr_writer :tag_names
	after_save :assign_tags
	
	# Finds related tasks by tag_id
	def self.tagged_with(tag_id)
		Tag.find(tag_id).tasks.find(:all)
	end
	
	def tag_names
		@tag_names || tags.map(&:name).join(' ')
	end
	
	private
	
	# Find or create task's tags by tag name and User.current_user.id
	# Class attribute User.current_user is set by before_filter:
	# "fetch_logged_in_user" and has same value as @current_user
	def assign_tags
		if @tag_names
			self.tags = @tag_names.split(/\s+/).map do |name|
				Tag.find_or_create_by_name_and_user_id(name, User.current_user.id)
			end
		end
	end
end
