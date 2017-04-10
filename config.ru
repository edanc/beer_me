require "roda"
require "brewery_db"
require "pry" if ENV["RACK_ENV"] == "development"
require 'dotenv/load'

class App < Roda
  plugin :json
  plugin :render
  plugin :environments


  configure :development, :production do
    route do |r|
      r.root do
        r.redirect "/beer_me"
      end
      # /beer_me
      r.on "beer_me" do
        @brewery_db = BreweryDB::Client.new do |config|
          config.api_key = ENV["BEER_ME"]
        end

        @beer = @brewery_db.beers.random(hasLabels: "y")
        # GET /beer_mee/random request
        # /hello request
        r.is do
          # GET /hello request
          r.get do
            render("beer_me")
          end
          r.post do
            {
              "response_type": "in_channel",
              "text": "Here is your beer!",
              "attachments": [
                "title": @beer["name_display"],
                "image_url": @beer["labels"]["large"],
                "fields": [
                  {
                    "title": "Description",
                    "value": @beer["description"],
                    "short": false
                  },
                  {
                    "title": "Abv",
                    "value": "#{@beer["abv"]}%",
                    "short": true
                  }
                ],
              ]
            }
          end
        end
      end
    end
  end
end

run App.freeze.app
