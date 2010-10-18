class User < ActiveRecord::Base
	has_many :tasks
	has_many :tags
	# Before filter fetch_logged_in_user sets this to @current_user
	cattr_accessor :current_user
end
