require "httparty"

class Base
  include HTTParty
  default_timeout 60

  def initialize(options = {})
    @city = options[:city]
  end

  def fetch
    @response = request_service
  end

  private

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
      code: (api_response["cod"] || api_response['status']).to_i,
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
    return cached_content if cached?

    yield.tap do |result|
      return handle_response(result)
    end
  end

  def handle_response(result)
    content = parse_content(result.body)

    if result.success?
      write_to_cache(content)
      build_success_response(content)
    else
      build_error_response(content)
    end
  end

  def cached?
    Rails.cache.exist?(cache_key)
  end

  def cached_content
    content = Rails.cache.fetch(cache_key)
    build_success_response(content)
  end

  def write_to_cache(content)
    Rails.cache.write(cache_key, content, expires_in: cache_expiration)
  end

  def parse_content(content)
    JSON[content]
  end
end
