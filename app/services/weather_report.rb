class WeatherReport < Base
  attr_accessor :options, :response

  base_uri        'api.openweathermap.org/data/'

  def initialize(options = {})
    @options = options
  end

  private

  def build_params
    request_params = {
      appid: Rails.application.secrets.weather_api_key,
      units: UNITS[:celsius],
    }

    if options[:city].present?
      request_params.merge(q: options[:city])
    elsif options[:lat].present? && options[:lon].present?
      request_params.merge(lat: options[:lat], lon: options[:lon])
    else
      request_params.merge(lat: rand_lat, lon: rand_lon)
    end
  end

  def rand_lat
    rand(-90.000000...90.000000)
  end

  def rand_lon
    rand(-180.000000...180.000000)
  end

  def build_icon_link(icon)
    "#{ICON_URL}/#{icon}.png"
  end

  def make_request
    self.class.get("/2.5/weather?", { query: build_params })
  end

  def cache_key
    if build_params[:q].present?
      "weather_app:city:#{ build_params[:q] }"
    else
      "weather_app:lat_x_lon:#{build_params[:lat]}_#{build_params[:lon]}"
    end
  end


  def read_from_cache
    @cached ||= Rails.cache.fetch(cache_key)
  end

  def build_response(api_response)
    if api_response["cod"] == 200
      build_success_response(api_response)
    else
      build_error_response(api_response)
    end
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

  def build_error_response(api_response)
    OpenStruct.new(
      code: api_response["cod"].to_i,
      message: api_response["message"],
      success?: false
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
