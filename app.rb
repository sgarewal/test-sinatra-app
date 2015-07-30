require 'sinatra'
require 'httparty'
require 'json'
require 'sinatra/twitter-bootstrap'
require 'sinatra/base'

class MyApp < Sinatra::Base
  register Sinatra::Twitter::Bootstrap::Assets
  get '/postcode' do
    response = HTTParty.get("http://mapit.mysociety.org/postcode/#{ params[:postcode] }")
    data = JSON.parse(response.body)
    constituency_id = data["shortcuts"]["WMC"]
    constituency = data["areas"][constituency_id.to_s]
    @constituency = constituency["name"]

    response = HTTParty.get("http://mapit.mysociety.org/postcode/#{ params[:postcode] }")
    data = JSON.parse(response.body)
    ward_info_id = data["shortcuts"]["ward"]
    ward_info = data["areas"][ward_info_id.to_s]
    @ward_info = ward_info["name"]

    response = HTTParty.get("http://mapit.mysociety.org/postcode/#{ params[:postcode] }")
    data = JSON.parse(response.body)
    council_info_id = data["shortcuts"]["council"]
    council_info = data["areas"][council_info_id.to_s]
    @council_info = council_info["name"]

    response = HTTParty.get("http://maps.googleapis.com/maps/api/geocode/json?address=#{ params[:postcode] }")
    geodata = JSON.parse(response.body)
    location = geodata["results"][0]["geometry"]["location"]
    @latitude = location["lat"]
    @longitude = location["lng"]
    erb :postcode
  end

  get '/' do
    erb :index
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
