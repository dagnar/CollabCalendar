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

# todo: break this api out into seperate files by concerns	
# class HoaForce < Sinatra::Application
# 	register Sinatra::ConfigFile
 	use Rack::Session::Cookie, expire_after: 2*7*24*60*60, secret: 'all_work_no_play_makes_us_a_dull_boy'

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
		'<p>Helro peoples</p>'
	end

# end
load './routes/user.rb'
load './routes/common-resource.rb'