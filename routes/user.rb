get '/user/new' do
  @title = "Hello"
  erb :user
end

get '/user/login' do
	@title = "hello"
	erb :login
end

post '/user/new' do
	# if User.where(email: params[:post][:email]).exists?
	# 	binding.pry
	# 	erb :fail
	# else
	binding.pry
		the_user = User.create!(
			:first_name => params[:first_name],
			:last_name => params[:last_name],
			:email => params[:email],
			:password => params[:password]
		)

		@name = "#{params[:first_name]} #{params[:last_name]}"
		token = the_user.generate_token
		#setting the cookie securely
		# response.set_cookie(@name, {value: token, secure: true)
		session[:userID] = token
	    session[:email] = params[:email]
	  
	  @title = "Hello #{@name}"
	  erb :hello
	# end
end

post '/user/login' do
	user = User.authenticate_password(params[:email], params[:password])
	if user
		@name = "#{params[:first_name]} #{params[:last_name]}"
		token = user.generate_token
		session[:userID] = token
		session[:email] = params[:email]
		content_type :json
		return user.to_json(:except => [:_id, :role, :created_at, :password_hash, :token_hash])
	else
		erb :fail
	end
		# @title = "hello #{@name}"
		# erb :hello
end

get '/user/logout' do
	erb :logout
end

post '/user/logout' do
	session.clear
	redirect '/'
	# response.delete_cookie "userID"
	# response.delete_cookie "email"
	# response.set_cookie('userID', value: nil, path: '/')
	# response.set_cookie('email', value: nil, path: '/')		
end

get '/users.json' do
	protected!
	content_type :json
	all_users = User.all
	all_users.to_json
end