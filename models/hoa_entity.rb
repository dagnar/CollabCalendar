class HOAEntity
	include Mongoid::Document
	include ScheduleUtility
	include IceCube

	field :name, 				type: String, required: true
	field :description,			type: String
	field :location, 			type: String
	field :unit_count, 			type: String
	field :schedules, 			type: Array, default: []

	validates_uniqueness_of :name, :message => "Already in use"	

	after_initialize :dehash_schedules #this is questionable, maybe not necessary to do this all the time.
	before_save :hash_schedules

end