class HomeAction < Cramp::Action
  ## run order like this:
	before_start :before_verify

  ## if response_with exist,run it and go next step

  ## else run on_star filter or star function if defined
  on_start :do_sth

  ## that will keep the connetion alive until finish
  keep_connection_alive

  ## that will run every 2 seconds
  periodic_timer :poll_new_user, :every => 2

  ## this will be run when finish
  on_finish :finish_request

  def poll_new_user
    p "periodic timer is running"
    last_user = rand 6
    
    if last_user == 5
      render "periodic timer finish this request!"
      finish
    else
      render "periodic timer is run!.........."
    end 
  end

  def before_verify
    puts "go before star filter!"
    if params[:test] == true
      halt 500, {'Content-Type' => 'text/plain'}, "Just a test, over with anything!"
    else
      yield
    end
  end

  def finish_request
    sleep 10 ## wait for periodic_timer run!
    puts "request finish"
    ## run erery request end,can`t render anything to client,just do sth on server!
    render "finish" ## just a joke
  end

  def respond_with
    p "respond_with"
    content_type = params[:format] == 'xml' ? 'application/xml' : 'application/json'
    [200, {'Content-Type' => content_type}]
  end

  def do_sth
    render "on_start!------->"
  end

end
