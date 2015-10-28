require 'spotty'

describe Spotty do

  let(:url) { "http://www.example.com/metadata/instance-termination" }
  let(:spotty) { Spotty.new(url) }

  describe "run" do
    context "when spot is scheduled for termination" do
      before(:each) do
        FakeWeb.register_uri(:get, "http://www.example.com/metadata/instance-termination", :body => "Nothing", :status => ["200", "Success"])     
        @response = Net::HTTP.get_response(URI.parse("http://www.example.com/metadata/instance-termination"))
      end
      
      it "returns 200 code" do
        expect(@response.code).to eq("200")
      end
      
      it "yields to block" do
        expect { |b| spotty.handle_response(@response, &b)}.to yield_with_no_args
      end
    end
    
    context "when spot is not scheduled for termination" do
      before(:each) do
        FakeWeb.register_uri(:get, "http://www.example.com/metadata/instance-termination", :body => "Nothing", :status => ["404", "Not Found"])     
        @response = Net::HTTP.get_response(URI.parse("http://www.example.com/metadata/instance-termination"))
      end
      
      it "returns 404 code" do
        expect(@response.code).to eq("404")
      end
      
      it "does not yield to block" do
        expect { |b| spotty.handle_response(@response, &b)}.not_to yield_control
      end
    end
  end
end

