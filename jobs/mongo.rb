#!/usr/bin/env ruby
require 'mongo'
include Mongo

SCHEDULER.every '15m', :first_in => 0 do |job|
	client = Mongo::Client.new(['127.0.0.1:27017'])
	db = client.database

	collection = client['posts']

	query = collection.count()
	puts query

	send_event('mongo_post_count', query)
	#send_event('mongo_user_count', db[:users].count())
end

