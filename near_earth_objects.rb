require 'faraday'
require 'figaro'
require 'pry'
require './services/neo_service'
# Load ENV vars via Figaro
Figaro.application = Figaro::Application.new(environment: 'production', path: File.expand_path('../config/application.yml', __FILE__))
Figaro.load

class NearEarthObjects
  def self.find_neos_by_date(date)
    # conn = Faraday.new(
    #   url: 'https://api.nasa.gov',
    #   params: { start_date: date, api_key: ENV['nasa_api_key']}
    # )
    # asteroids_list_data = conn.get('/neo/rest/v1/feed')
    #
    # parsed_asteroids_data = JSON.parse(asteroids_list_data.body, symbolize_names: true)[:near_earth_objects][:"#{date}"]
    parsed_asteroids_data = NeoService.new.asteroids_list_data(date)

    {
      asteroid_list: formatted_asteroid_data(parsed_asteroids_data),
      biggest_asteroid: largest_asteroid_diameter(parsed_asteroids_data),
      total_number_of_asteroids: parsed_asteroids_data.count
    }
  end

  def self.formatted_asteroid_data(parsed_asteroids_data)
   parsed_asteroids_data.map do |asteroid|
      {
        name: asteroid[:name],
        diameter: "#{asteroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i} ft",
        miss_distance: "#{asteroid[:close_approach_data][0][:miss_distance][:miles].to_i} miles"
      }
    end
  end

  def self.largest_asteroid_diameter(parsed_asteroids_data)
    parsed_asteroids_data.map do |asteroid|
      asteroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i
    end.max { |a,b| a<=> b}
  end
end
