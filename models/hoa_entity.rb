class HOAEntity
	include Mongoid::Document

	field :name, 						type: String, required: true
	field :description,			type: String
	field :location, 				type: String
	field :unit_count, 			type: String
	field :calendar

end