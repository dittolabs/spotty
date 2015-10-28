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
    # According to the spot termination documentation notice documentation
    # http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-interruptions.html
    # if an instance is scheduled for termination, calling the meta-data url
    # will return in a response with a time value, e.g. '2015-01-05T18:02:00Z'.
    # if an instance is NOT scheduled for termination, the response can either
    # be an HTTP 404 error or have a value that is not a time value.
    
    case res
    when Net::HTTPSuccess then
      time_value = res.body.lines.grep(/.*T.*Z/)
      if time_value.empty?
        puts "200 returned, but no time value. Spot not scheduled for termination"
        sleep(@interval)
      else
        @continue_poll = false
        yield
      end
    when Net::HTTPNotFound
      puts "404 returned. Spot not scheduled for termination"
      sleep(@interval)
    else
      puts response.value
    end
  end
end
