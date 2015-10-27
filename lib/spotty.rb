require 'uri'
require 'net/http'

class Spotty
  def initialize(uri=nil, opts = {})
    uri = 'http://169.254.169.254/latest/meta-data/spot/termination-time' if uri.nil?
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
          yield
          continue_poll = false
        when Net::HTTPNotFound
          puts "404 returned. Spot not scheduled for termination"
        else
          puts response.value
        end
      rescue Exception => e
        puts "Error for #{@uri}: #{e}"
        continue_poll = false
      end
    end
  end
end
