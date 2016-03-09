#!/usr/bin/env ruby
require 'net/https'
require 'uri'
require 'json'

# this job will track some metrics of a facebook page

# Config
# ------
# the fb id or username of the page you’re planning to track
facebook_graph_username = ENV['FACEBOOK_GRAPH_USERNAME'] || 'readgoodstuff'

SCHEDULER.every '1m', :first_in => 0 do |job|
  uri = URI.parse("https://graph.facebook.com/v2.5/1739316632952993?fields=name,likes,talking_about_count,new_like_count&access_token=CAACEdEose0cBAEwpAgABAmRp5ivjhpVwikwSwU2alcuCKBAMKGWGObcfIRfvzphhMeLZCVPv5gKeWlpn1dzcsF1cAvJUWjIzzZACkVbTYOGtVno7oU3n2wagjvpgsgK5c9HAvzwgDG74J13zie0Fy4DpwbzLzVDPruZBwTOpfGDHSOEcjyQFr3HdDtHZAcZAziIbWyCPYDAZDZD")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(request)

  if response.code != "200"
    puts "facebook graph api error (status-code: #{response.code})\n#{response.body}"
  else 
    data = JSON.parse(response.body)
    if data['name']
      if defined?(send_event) 
        send_event('facebook_likes', current: data['likes'])
        send_event('facebook_talking_about_count', current: data['talking_about_count'])
        send_event('facebook_new_like_count', current: data['new_like_count'])
      else
        printf "Facebook likes: %d, checkins: %d, were_here_count: %d, talking_about_count: %d\n",
          data['likes'],
          data['checkins'],
          data['were_here_count'],
          data['talking_about_count']
      end
    end
  end
end