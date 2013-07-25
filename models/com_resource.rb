class ComResource
	include Mongoid::Document
	include IceCube

	# attr_accessor :name, :description, :bookable, :location

	field :name, 						type: String, required: true
	field :bookable, 				type: Boolean, default: true
	field :description, 		type: String
	field :location, 				type: String
	field :time_limit,			type: Integer	#in minutes
	field :schedules, 			default: Array.new


	validates_presence_of :name
	validates_inclusion_of :bookable, in:[true, false]
	validates_uniqueness_of :name, :message => "Already in use"

# 	def add_schedule(sc)
# 		schedules.each do |s|
# 			if s.occurs_between?(sc.start_time, sc.end_time)
# 				return 		#scheduling conflict
# 			end
# 		end
# binding.pry
# 		if (sc.duration / 60) <= time_limit 
# 			schedules << sc
# 		end
# 	end

	def add_schedule(options)
		binding.pry
		if options[:name] and options[:start_time] and options[:end_time]
			sc = Schedule.new(options[:start_time], {end_time: options[:end_time], hoa_attributes: {name: options[:name]}})
		elsif options[:name] and options[:schedule]
			sc = options[:schedule]
		end

		if sc
			schedules.each do |s|
				if s.occurs_between?(sc.start_time, sc.end_time)
					return 		#scheduling conflict
				end
			end
	binding.pry
			if time_limit
				if (sc.duration / 60) <= time_limit 
					schedules << sc				
				end
			else
				schedules << sc
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

