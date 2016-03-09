require 'twitter'


#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = 'mhTHO9DSJM9biUBHQDRxYBCIj'
  config.consumer_secret = '  TCk3WuwFDxntPvwasivDWbX25LPLwimLFhY7zskZywykrPJV1X'
  config.access_token = ' 4217786393-Uqr0wcJlOP2G6V7LWEuDzepyyef6h3ILBsGGsgc'
  config.access_token_secret = 'Ts3HVeUfztYsKbjquyYpr7rRHJgXO7ndT6oGtukUvpXk8'
end

search_term = URI::encode('@read_good_stuff')

SCHEDULER.every '10m', :first_in => 0 do |job|
  begin
    tweets = twitter.search("#{search_term}")

    if tweets
      tweets = tweets.map do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end