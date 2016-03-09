#!/usr/bin/env ruby
require 'mongo'
include Mongo

SCHEDULER.every '15m', :first_in => 0 do |job|
	db = Mongo::Client.new(['127.0.0.1:27017'], :database => 'readgoodstuff')

	send_event('mongo_post_count', db[:posts].count())
	send_event('mongo_user_count', db[:users].count())
end

