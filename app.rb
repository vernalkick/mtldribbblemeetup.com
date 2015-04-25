require 'rest-client'

class App < Sinatra::Base
  configure do
    set :root, File.dirname(__FILE__)
  end

  get '/' do
    @people = twitter.users(people)

    latest_event = events.last
    last_event_date = Date.parse(latest_event['date'])

    if last_event_date > DateTime.now
      latest_event['map_url'] = "https://www.google.ca/maps/place/#{latest_event['location'].gsub(' ', '+')}"
      @event = latest_event
    end

    erb :home, locals: { people: @people, event: @event }
  end

  def people
    YAML.load_file File.join(settings.root, 'people.yml')
  end

  def events
    YAML.load_file File.join(settings.root, 'events.yml')
  end

  private

  def twitter
    # Twitter::REST::Client.new do |config|
    #   config.consumer_key        = "BpbHvdxTiAWdgfMHsfdQsBd9O"
    #   config.consumer_secret     = "0FVKBjqVzCr2LHeeVDNcsmM87Ie0kqiRlKeZLzN4Duf22zQ4gU"
    #   config.access_token        = "32622651-ZQM1EQ8bkpJyjXVzFBGpIN3FzWtNMJZL6HB8KkA4O"
    #   config.access_token_secret = "Z1FSfitCgl2CChwEDdroZChP7rcDH6i0jlDuL5LNaOomX"
    # end
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end

  end
end
