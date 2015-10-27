module ResponseHelper
  def success_response(body)
    FakeResponse.new(body, 200)
  end

  def not_found_response(body)
    FakeResponse.new(body, 404)
  end

  class FakeResponse
    attr_reader :body, :code

    def initialize(body, code)
      @body = body
      @code = code
    end
  end
end
