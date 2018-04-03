require 'typhoeus'

module Gorgerb
  class Client
    def initialize(url, user: nil, password: nil, connect_timeout: 1, timeout: 2, user_agent: 'gorgerb')
      @url           = url
      @http_user     = user
      @http_password = password

      @connect_timeout = connect_timeout
      @timeout         = timeout

      Typhoeus::Config.user_agent = user_agent
    end

    def player_statistics(steam_id)
      response = request("players/#{ steam_id }/statistics")

      PlayerStatistics.from_hsh(response)
    rescue KeyError => e
      raise APIError, "Incomplete JSON returned: #{ e.message }"
    end

    private
    def request(path, method: :get)
      request = build_request(path, method: :get)
      request.run

      response = request.response

      if response.success?
        JSON.parse(response.body)
      elsif response.timed_out?
        raise APIError, 'Timeout while querying API'
      elsif response.code == 404
        raise NoSuchPlayerError, "No such player: #{ response.body }"
      else
        raise APIError, "Non-success status-code while querying the API: #{ response.code }"
      end

    rescue JSON::ParserError
      raise APIError, 'Invalid JSON received from API'
    end

    def build_request(path, method: :get)
      opts = {
        connecttimeout: @connect_timeout,
        timeout: @timeout
      }
      opts[:userpwd] = "#{ @http_user }:#{ @http_password }" if @http_user && @http_password

      url = "#{ @url }/#{ path }"

      Typhoeus::Request.new(
        url,
        opts
      )
    end
  end
end
