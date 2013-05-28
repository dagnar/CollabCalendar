require 'rubygems'
require 'bundler/setup'
require 'mongoid'
require 'json'
require 'sinatra'
require 'warden'
require 'bcrypt'
require 'pry'
require "securerandom"
require './models/user.rb'


#for models
Dir["./models/*.rb"].each { |file| require file }

# MongoDB configuration
Mongoid.configure do |config|
  if ENV['MONGOHQ_URL']
    conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
    uri = URI.parse(ENV['MONGOHQ_URL'])
    config.master = conn.db(uri.path.gsub(/^\//, ''))
  else
    config.master = Mongo::Connection.from_uri("mongodb://localhost:27017").db('test')
  end
end

 # class HoaForce < Sinatra::Application
# 	register Sinatra::ConfigFile
# 	use Rack::Session::Cookie

	enable :sessions


	# set utf-8 for outgoing
	before do
	  headers "Content-Type" => "text/html; charset=utf-8"
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
				:first_name => params[:post][:first_name],
				:last_name => params[:post][:last_name],
				:email => params[:post][:email],
				:password => params[:post][:password]
			)

			@name = "#{params[:post][:first_name]} #{params[:post][:last_name]}"
			token = the_user.generate_token
			#setting the cookie securely
			# response.set_cookie(@name, {value: token, secure: true)
			response.set_cookie(@name, token)
		  
		  
		  @title = "Hello #{@name}"
		  erb :hello
		# end
	end

	get '/user/login' do
		@title = "hello"
		erb :login
	end

	post '/user/login' do
		user = User.authenticate_password(params[:post][:email], params[:post][:password])
		if user
			'junk'
			@name = "#{params[:post][:first_name]} #{params[:post][:last_name]}"
			token = user.generate_token
			response.set_cookie(@name, token)
			content_type :json
			return user.to_json(:except => [:_id, :role, :created_at, :password_hash, :token_hash])
		else
			return nil
		end
			# @title = "hello #{@name}"
			# erb :hello
	end

	get '/users.json' do
		content_type :json
		all_users = User.all
		all_users.to_json
	end

# end