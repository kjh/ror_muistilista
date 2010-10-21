# TasksController
#
# user_id field can't be changed with params hash
#
class TasksController < ApplicationController
	# All actions require login
	before_filter :login_required
	
  	# GET /tasks
  	def index
  		if params[:taggings]
    		@tasks = Task.tagged_with(params[:taggings])
    		@find_by_tagging = @current_user.tags.find(params[:taggings])
		else
			@tasks = @current_user.tasks.find(:all, :order => :position)
			@find_by_tagging = nil
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
  		# Build new task object with params
   		@task = @current_user.tasks.build params[:task]
   		# Calculate default values before save
   		# Before save
   		@task.status = false 
   		# If count = 0 position = 0 etc. 
  		@task.position = @current_user.tasks.count(:conditions => { :status => false }) 
  		# Save 		
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
  		# Task before update
  		@task = @current_user.tasks.find(params[:id])
  		
  		@before_update = nil
  		@sortable = false
  		
  		# Ajax update (state change OR reorder)
  		if request.format.js?
  			# update task positions
    		if params[:list]
    			# Ajax reorder
    			@sortable = true
    			@sort = params[:list][:order]
    			@sort.each do |s|
    				item = s.split('_')
    				t = Task.find(item[1])
    				t.update_attributes(:position => item[0])
				end
			else 
				# Ajax state change 			
  				# Task object state before update
  				@before_update = Task.new do |t|
  					t.name = @task.name
  					t.position = @task.position
  					t.status = @task.status
  				end
  		
  				# Set position -> append to opposite list
  				if @task.status # inverse of params[:status]
  					@task.position = @current_user.tasks.count(:conditions => { :status => false }) 
  				else
  					@task.position = @current_user.tasks.count(:conditions => { :status => true }) 
  				end
  			end
  		end # end Ajax update
  		  		
  		
  		respond_to do |format|
  	  	  	if @task.update_attributes(params[:task])
  	  	  		flash[:notice] = 'Task was successfully updated.'
  	  	  	  	format.html { redirect_to tasks_path }
  	  	  	  	# Ajax update IS state change OR reorder
  	  	  	  	format.js { Task.reorder_after(@before_update, "delete") unless @sortable }
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
  	    # Reorder after delete
  	    Task.reorder_after(@task, "delete")

  	  	respond_to do |format|
  	  	  	format.html { redirect_to(tasks_url) }
  	  	end
  	end
end
