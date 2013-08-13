###Gets
get '/common-resource/new' do
	protected!
	erb :com_resource_form
end

get '/common-resource/book' do
	protected!

	@all_com_resources = ComResource.all
	erb :book_resource
end

get 'common-resource/all.json' do
	protected!
	content_type :json
	all_com_resources = ComResource.all
	all_com_resources.to_json
end

###Posts
post '/common-resource/new' do
	protected!
	binding.pry
	the_resource = ComResource.create!(
		:name => params[:name],
		:bookable => params[:bookable],
		:description => params[:description],
		:location => params[:location]
	)
	erb :hello
end

post '/common-resource/book' do
	binding.pry
	user_id = protected!
	binding.pry
	the_resources = ComResource.where(_id: params[:crId])
	the_resource = the_resources.first
	if the_resource
		start_date = Date.parse(params[:startDate])
		start_time = Time.parse(params[:startTime])
		end_time = Time.parse(params[:endTime])

		starter = Time.new(start_date.year, start_date.month, start_date.day, start_time.hour, start_time.min)
		ender = Time.new(start_date.year, start_date.month, start_date.day, end_time.hour, end_time.min) 

		success = the_resource.add_schedule({name: params[:name], owner_id: user_id, start_time: starter, end_time: ender})
		binding.pry
		if success
			the_resource.save
		end
	end

	erb :hello
end

