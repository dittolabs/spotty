require 'uri'
require 'net/http'

class Spotty
  def initialize(uri=nil, opts = {})
    uri = 'http://169.254.169.254/latest/meta-data/spot/termination-time' if uri.nil?
    @uri = URI.parse(uri)
    @interval = opts[:interval] || 5
    @net_http = Net::HTTP
    @continue_poll = true
  end

  def run
    while @continue_poll
      begin
        res = @net_http.get_response(@uri)
        handle_response(res) {yield}
      rescue Exception => e
        puts "Error for #{@uri}: #{e}"
        @continue_poll = false
      end
    end
  end

  def handle_response(res)
    case res
    when Net::HTTPSuccess then
      @continue_poll = false
      yield
    when Net::HTTPNotFound
      puts "404 returned. Spot not scheduled for termination"
      sleep(@interval)
    else
      puts response.value
    end
  end
end
