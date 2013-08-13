require './modules/schedule_utility.rb'

class ComResource
	include Mongoid::Document
	include ScheduleUtility
	include IceCube


	# attr_accessor :name, :description, :bookable, :location

	field :name, 				type: String, required: true
	field :bookable, 			type: Boolean, default: true
	field :description, 		type: String
	field :location, 			type: String
	field :time_limit,			type: Integer	#in minutes
	field :schedules, 			type: Array, default: []


	validates_presence_of :name
	validates_inclusion_of :bookable, in:[true, false]
	validates_uniqueness_of :name, :message => "Already in use"	

	after_initialize :dehash_schedules #this is questionable, maybe not necessary to do this all the time.
	before_save :hash_schedules

	# def schedules
	# 	dehash_schedules
	# 	@ice_schedules
	# end


end



