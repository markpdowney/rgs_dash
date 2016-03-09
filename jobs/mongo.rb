#!/usr/bin/env ruby
require 'mongo'
include Mongo

SCHEDULER.every '15m', :first_in => 0 do |job|
	client = Mongo::Client.new(['127.0.0.1:27017'], :database => 'readgoodstuff')
	db = client.database

	post_table = client['posts']
	post_count = post_table.count()

	user_table = client['users']
	user_count = user_table.count()

	#puts post_count
	#puts user_count

	send_event('mongo_post_count', current: post_count)
	send_event('mongo_user_count', current: user_count)
end

