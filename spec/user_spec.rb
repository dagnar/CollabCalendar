require 'spec_helper'
require_relative '../models/user'

describe User do
	let(:the_user) { User.create!(
			first_name: 'joey',
			last_name: 'boey',
			email: 'joey@boey.com',
			password: 'asdfasdf'
			) }
	
	it "should create a user with attributes" do
		# the_user = 
		the_user.first_name.should == 'joey'
		the_user.last_name.should == 'boey'
		the_user.email.should == 'joey@boey.com'
	end

	it "should generate a token" do
		the_user.generate_token.length.should > 0
	end

end