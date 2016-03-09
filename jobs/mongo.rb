#!/usr/bin/env ruby
require 'mongo'
include Mongo

SCHEDULER.every '15m', :first_in => 0 do |job|
	db = Connection.new.db('readgoodstuff')

	users = db.collection('users')
	posts = db.collection('posts')

	send_event('mongo_post_count', posts.count())
	send_event('mongo_user_count', users.count())
end

