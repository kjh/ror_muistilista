class Task < ActiveRecord::Base
	# ActiveRecord associations
	belongs_to :user
	has_many :taggings, :dependent => :destroy
	has_many :tags, :through => :taggings
	# Protected attribute (objects owner can't be set by user request)
	attr_protected :user_id
	# Setter method for tag_names
	attr_writer :tag_names
	# After task object save save tags
	after_save :assign_tags
	
	# Finds related tasks by tag_id
	def self.tagged_with(tag_id)
		Tag.find(tag_id).tasks.find(:all, :order => :position)
	end
	
	# Getter for tag_names
	def tag_names
		@tag_names || tags.map(&:name).join(' ')
	end
	
	# Keep task items in order
	def self.reorder_after(item, action)
		if action == 'delete'
			logger.info 'REORDER (after delete or status update)'
			logger.info '==========================================='
			logger.info 'Removed item name:' 		+ item.name 
			logger.info 'Removed item status:' 		+ item.status.to_s 
			logger.info 'Removed item position:' 	+ item.position.to_s 
			logger.info '==========================================='
			if item.status
				Task.find_all_by_status_and_user_id(true, User.current_user.id).each do |complete|
					if item.position < complete.position 
						complete.position -= 1
						complete.save
					end						
				end
			else
				Task.find_all_by_status_and_user_id(false, User.current_user.id).each do |incomplete|
					if item.position < incomplete.position 
						incomplete.position -= 1
						incomplete.save
					end						
				end
			end
		end
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
