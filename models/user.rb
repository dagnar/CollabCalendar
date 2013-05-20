require "digest"

class User
	include Mongoid::Document
	include BCrypt

	field :first_name, 						type: String
	field :last_name, 						type: String
	field :email, 								required: true, type: String
	field :role,									type: String, default: 'user'
	field :password_hash, 				type: String
	field :token_hash,						type: String
	field :create_at, 						type: DateTime

	validates_presence_of :first_name, :last_name, :email
	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "must be a valid email address"
	validates_length_of :password, :minimum => 8, :maximum => 48, :message => "must be between 8 and 48 characters", :if => "password_changed?"
	# validates_presense_of :password, :on => :create, :message => "Can't be blank."
	validates_uniqueness_of :email, :message => "Already in use"
	# validates :email, presence: true, length: { allow_blank: false}

	attr_accessor :password

	index({ email: 1 }, { unique: true, name: "email_index"})

	def self.authenticate_password(email, password)
		user = User.where(email: email).first
		if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
			user
		else
			nil
		end
	end

	def self.authenticate_token(email, token)
		user = User.where(email: email).first
		if user && user.token_hash = Digest::SHA1.hexdigest(token)
	end

  def password_changed?
    if self.password.nil?
      false
    end
    puts self.password
    true
  end

	def saved_password
    @saved_password ||= BCrypt::Password.new(password_hash)
  end
  
  def saved_password=(new_password)
    @saved_password = BCrypt::Password.create(new_password)
    self.encrypted_password = @saved_password
  end
  
  def encrypt_password
    saved_password = password if password.present?
  end

  def generate_token
  	begin
  		pre_hash_token = SecureRandom.hex
  		self.update_attribute!(token_hash: Digest::SHA1.hexdigest(pre_hash_token))
  		pre_hash_token
  	rescue 
  		return nil
  	end
  end

end