#Not ideal, this module is tightly coupled
module ScheduleUtility
	include IceCube

	def add_schedule(options)
		if options[:name] and options[:owner_id] and options[:start_time] and options[:end_time]
			sc = Schedule.new(options[:start_time], {end_time: options[:end_time], 
								hoa_attributes: {name: options[:name], owner_id: options[:owner_id]} })
		elsif options[:name] and options[:schedule]
			sc = options[:schedule]
		end

		if sc
			@ice_schedules.each do |s|
				if s.occurs_between?(sc.start_time, sc.end_time)
					return false						
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
			if !self.attributes['schedules'].nil?	
				self.attributes['schedules'].each do |s|					
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

	def to_hash
		datas = Array.new

		@ice_schedules.each do |s|
			data = {}
			data[:start] = s.start_time
			data[:end] = s.end_time
			# s.hoa_attributes.each do |key, value|
			# 	data[key.to_symbol] = value
			# end
			data[:hoa_attributes] = s.hoa_attributes
			datas << data
		end

		datas
	end

end