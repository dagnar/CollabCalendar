require 'bcrypt'

class User
	include Mongoid::Document
	include BCrypt

	field :first_name, type: String
	field :last_name, type: String
	field :email, type: String

end