require 'rubygems'
require 'bundler/setup'
require 'mongoid'
require 'json'
require 'sinatra'
require 'warden'
require 'bcrypt'
require 'pry'
require 'securerandom'
require 'ice_cube'
require './models/user.rb'


#for models
Dir["./models/*.rb"].each { |file| require file }

# MongoDB configuration
Mongoid.configure do |config|
  if ENV['MONGOHQ_URL']
    conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
    uri = URI.parse(ENV['MONGOHQ_URL'])
    config.master = conn.db(uri.path.gsub(/^\//, ''))
  end
  if ENV['RACK_ENV'] == 'development'
    config.master = Mongo::Connection.from_uri("mongodb://localhost:27017").db('test')
  end
  if ENV['RACK_ENV'] == nil
  	config.master = Mongo::Connection.from_uri("mongodb://localhost:27017").db('rspec')
  end
end

 # class HoaForce < Sinatra::Application
# 	register Sinatra::ConfigFile
 	use Rack::Session::Cookie, expire_after: 2*7*24*60*60, secret: 'luis_is_a_full_blown_moron'

	# enable :sessions

	# set utf-8 for outgoing
	before do
	  headers "Content-Type" => "text/html; charset=utf-8"
	end

	helpers do
		def logged_in?
			token = session[:userID]
			email = session[:email]
			user = User.authenticate_token(email, token)

			if user
				true
			else
				false
			end
		end

		def protected!
			halt [ 401, 'Not Authorized' ] unless logged_in?
		end
	end

	get '/' do
		'<p>Helro bastards</p>'
	end

	get '/user/new' do
	  @title = "Hello"
	  erb :form

	  # session["value"] ||= "hello fuckers"
	  # response.set_cookie("ball", "s")
	  # "cookie value: #{session["value"]}"
	end

	post '/user/new' do
		# if User.where(email: params[:post][:email]).exists?
		# 	binding.pry
		# 	erb :fail
		# else
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

	get '/user/login' do
		@title = "hello"
		erb :login
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

	get '/common-resource/new' do
		protected!
		erb :com_resource_form
	end

	post '/common-resource/new' do
		protected!
		binding.pry
		the_resource = ComResource.create!(
			:name => params[:name],
			:bookable => params[:bookable],
			:description => params[:description],
			:location => params[:location]
		)
		erb :hello
	end

	get '/common-resource/book' do
		protected!

		@all_com_resources = ComResource.all
		erb :book_resource
	end

	post '/common-resource/book' do
		protected!
		
		
		the_resources = ComResource.where(_id: params[:crId])
		the_resource = the_resources.first
		if the_resource
			start_date = Date.parse(params[:startDate])
			start_time = Time.parse(params[:startTime])
			end_time = Time.parse(params[:endTime])

			starter = Time.new(start_date.year, start_date.month, start_date.day, start_time.hour, start_time.min)
			ender = Time.new(start_date.year, start_date.month, start_date.day, end_time.hour, end_time.min) 
	
			the_resource.add_schedule({name: params[:name], start_time: starter, end_time: ender})
			binding.pry
			the_resource.save
		end

		status 200
	end

	get '/com_resources.json' do
		protected!
		content_type :json
		all_com_resources = ComResource.all
		all_com_resources.to_json
	end

# end