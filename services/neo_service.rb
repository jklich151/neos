class NeoService

  def conn(date)
    Faraday.new(
      url: 'https://api.nasa.gov',
      params: { start_date: date, api_key: ENV['nasa_api_key']}
    )
  end

  def asteroids_list_data(date)
    response = conn(date).get('/neo/rest/v1/feed')
    JSON.parse(response.body, symbolize_names: true)[:near_earth_objects][:"#{date}"]
  end
end
