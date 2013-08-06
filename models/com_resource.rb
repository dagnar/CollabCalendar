class ComResource
	include Mongoid::Document
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

	#after_initialize :dehash_schedules
	before_save :hash_schedules

	def add_schedule(options)
		dehash_schedules
		if options[:name] and options[:start_time] and options[:end_time]
			sc = Schedule.new(options[:start_time], {end_time: options[:end_time], hoa_attributes: {name: options[:name]}})
		elsif options[:name] and options[:schedule]
			sc = options[:schedule]
		end

		if sc
			@ice_schedules.each do |s|
				if s.occurs_between?(sc.start_time, sc.end_time)
					return false		#schedu			if (sc.duration / 60) <= time_limit 						
				end												
			end
			@ice_schedules << sc
		end

		return true
	end

	#de-hash schedules to instance variable
	def dehash_schedules
		#is this first time dehashing schedules?
		if @ice_schedules.nil?
			@ice_schedules = Array.new
			if !self.schedules.nil?	
				self.schedules.each do |s|					
					@ice_schedules << Schedule.from_hash(s)
				end
			end
		end
	end

	def hash_schedules
		#clear out schedules
		self.schedules = []
		if !@ice_schedules.nil? and @ice_schedules.length > 0
			@ice_schedules.each do |sc|
				self.schedules << sc.to_hash
			end
		end
	end

	# def add_schedule(name, start_time, end_time)
	# 	binding.pry
		
	# 	add_schedule(sc)
	# end

	def to_hash
		datas = Array.new

		schedules.each do |s|
			data = {}
			data[:start] = s.start_time
			data[:end] = s.end_time
			data[:name] = s.hoa_attributes[:name]
			datas << data
		end

		datas
	end



end



