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

	get '/' do
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
		  
		  @title = "Hello #{@name}"
		  erb :hello
		# end
	end

	get '/users.json' do
		content_type :json
		all_users = User.all
		all_users.to_json
	end

# end