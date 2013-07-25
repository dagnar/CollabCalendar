class HOARule
	include Mongoid::Document
	
	attr_accessor :name, :owner, :created_date

end

