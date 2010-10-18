# TasksController
#
# user_id field can't be changed with params hash
#
class TasksController < ApplicationController
	# All actions require login
	before_filter :login_required
	
  	# GET /tasks
  	def index
  		# Fetch tasks
    	if params[:taggings]
    		@tasks = Task.tagged_with(params[:taggings])
    		#@selected_tag_id
		else
			# Current user's tasks
  			@tasks = @current_user.tasks.find(:all, :order => :position)
			#@selected_tag_id
		end
  	  
  	  	respond_to do |format|
  	  	  	format.html # index.html.erb
  	  	end
  	end

  	# GET /tasks/1
  	def show
  		# Current user's task
  		@task = @current_user.tasks.find(params[:id])
  		
  	  	respond_to do |format|
  	  	  	format.html # show.html.erb
  	  	end
  	end

  	# GET /tasks/new
  	def new
  		# Current user's task
  	  	@task = @current_user.tasks.new

  	  	respond_to do |format|
  	  	  format.html # new.html.erb
  	  	end
  	end

  	# GET /tasks/1/edit
  	def edit
  		# Current user's task
  		@task = @current_user.tasks.find(params[:id])
  	end

  	# POST /tasks
  	def create
  		# Current user's task 
  		@task = @current_user.tasks.build params[:task]
  		respond_to do |format|
  			if @task.save
  	      		flash[:notice] = 'Task was successfully created.'
  	      		format.html { redirect_to tasks_path }
  	    	else
  	      		format.html { render :action => "new" }
  	    	end
  	  	end
  	end

  	# PUT /tasks/1
  	def update
  		# Current user's task
  		@task = @current_user.tasks.find(params[:id])
  		
  	  	respond_to do |format|
  	  	  	if @task.update_attributes(params[:task])
  	  	  	  	flash[:notice] = 'Task was successfully updated.'
  	  	  	  	format.html { redirect_to tasks_path }
  	  	  	else
  	  	  	  	format.html { render :action => "edit" }
  	  	  	end
  	  	end
  	end

  	# DELETE /tasks/1
  	def destroy
  		# Current user's task
  		@task = @current_user.tasks.find(params[:id])
  	    @task.destroy

  	  	respond_to do |format|
  	  	  	format.html { redirect_to(tasks_url) }
  	  	end
  	end
end
