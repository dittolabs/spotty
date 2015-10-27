require 'uri'
require 'net/http'

class Spotty
  def initialize(uri, opts = {})
    @uri = URI.parse(uri)
    @interval = opts[:interval] || 5
    @net_http = Net::HTTP
  end

  def run
    continue_poll = true
    while continue_poll
      sleep_interval = @interval
      begin
        res = @net_http.get_response(@uri)
        case res
        when Net::HTTPSuccess then
          yield actions
        when Net::HTTPNotFound
          puts "404 returned. Spot not scheduled for termination"
        else
          puts response.value
        end
      rescue Exception => e
        puts "Error for #{@uri}: #{e}"
      end
    end
  end
end
