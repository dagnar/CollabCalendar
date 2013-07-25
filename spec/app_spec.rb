# require 'app'
# require 'rspec'
# require 'rack/test'
# # require './models/com_resource.rb'

# set :environment, :test

# describe 'Test Test' do 
# 	include Rack::Test::Methods
# 	it "should respond to GET" do
		
# 		get '/'
# 		last_response.should be_ok		
# 	end
	
# end

require 'spec_helper'

describe "Sinatra App" do

  it "should respond to GET" do
    get '/'
    last_response.should be_ok
    last_response.body.should match(/Helro bastards/)
  end

end