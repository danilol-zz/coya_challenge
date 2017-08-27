class WeatherReport < Base
  attr_accessor :city, :response

  base_uri        "api.openweathermap.org/data/"

  private

  def build_params
    request_params = {
      appid: Rails.application.secrets.weather_api_key,
      units: UNITS[:celsius],
    }

    request_params.merge(q: city) if city.present?
  end

  def build_icon_link(icon)
    "#{ICON_URL}/#{icon}.png"
  end

  def make_request
    self.class.get("/2.5/weather?", { query: build_params })
  end

  def cache_key
    "weather_app:city:#{ build_params[:q] }" if build_params[:q].present?
  end

  def build_success_response(api_response)
    OpenStruct.new(
      code: api_response["cod"],
      city: api_response["name"],
      country: api_response["sys"]["country"],
      lat: api_response["coord"]["lat"],
      lon: api_response["coord"]["lon"],
      weather: {
        main: api_response["weather"][0]["main"],
        description: api_response["weather"][0]["description"],
        icon: build_icon_link(api_response["weather"][0]["icon"]),
        temp: api_response["main"]["temp"],
        min: api_response["main"]["temp_min"],
        max: api_response["main"]["temp_max"],
        humidity: api_response["main"]["humidity"],
        pressure: api_response["main"]["pressure"]
      },
      success?: true
    )
  end

  ICON_URL    = "http://openweathermap.org/img/w".freeze

  UNITS = {
    fahrenheit: "imperial",
    celsius:    "metric",
    kelvin:     "",
  }.freeze

  def cache_expiration
    5.minutes
  end
end
