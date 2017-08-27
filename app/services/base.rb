require "httparty"

class Base
  include HTTParty
  default_timeout 60

  def fetch
    @response = request_service
  end

  def request_service
    begin
      handle_timeouts do
        handle_caching do
          make_request
        end
      end
    rescue => e
      build_error_response({ "cod" => 500, "message" => "Internal Error"})
    end
  end

  def build_error_response(api_response)
    OpenStruct.new(
      code: api_response["cod"].to_i,
      message: api_response["message"],
      success?: false
    )
  end

  def handle_timeouts
    begin
      yield
    rescue Net::OpenTimeout, Net::ReadTimeout
      build_error_response({ "cod" => 408, "message" => "Request Timeout: execution expired" })
    end
  end

  def handle_caching
    if cached = Rails.cache.fetch(cache_key)
      build_success_response(cached)
    else
      yield.tap do |result|
        if result.success?
          Rails.cache.write(cache_key, JSON[result.body], expires_in: CACHE_EXPIRATION)
          return build_success_response(JSON[result.body])
        end

        return build_error_response(JSON[result.body])
      end
    end
  end
end
