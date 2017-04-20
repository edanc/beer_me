require "roda"
require "brewery_db"
require "pry" if ENV["RACK_ENV"] == "development"
require 'dotenv/load'
require 'tilt'
require_relative 'beer'

class App < Roda
  plugin :json
  plugin :render
  plugin :environments

  configure :development, :production do
    route do |r|
      r.root do
        r.redirect "/beer_me"
      end
      @brewery_db = BreweryDB::Client.new do |config|
        config.api_key = ENV["BEER_ME"]
      end

      r.on "beer" do
        r.is do
          r.get do

          end
          r.post do

          end
        end
      end
      # /beer_me
      r.on "beer_me" do
        beer = @brewery_db.beers.random(hasLabels: "y")
        @beer = Beer.new(beer)
        r.is do
          r.get do
            render("beer_me")
          end
          r.post do
            @beer.beers_json
          end
        end
      end
    end
  end
end

run App.freeze.app
