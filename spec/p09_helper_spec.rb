require 'webrick'
require 'phase6/router'
require 'phase9/controller_base'

describe Phase9::Router do
  let(:router) { Phase9::Router.new }
  let(:req) { WEBrick::HTTPRequest.new(Logger: nil) }
  let(:res) { WEBrick::HTTPResponse.new(HTTPVersion: '1.0') }
  let(:ctrlr) { UserController.new(req, res) }
  let(:user) { double("user") }
  let(:user_id) { 7 }

  before(:each) do
    class UserController < Phase9::ControllerBase
    end

    # Allowances
    allow(req).to receive(:host) { "localhost" }
    allow(user).to receive(:id) { user_id }

    router.add_route(Regexp.new("^/users$"), :get, UserController, :index)
    router.add_route(Regexp.new("^/users/(?<id>\\d+)$"), :get, UserController, :show)

    UserController.define_route_helpers(router.routes)
  end

  it "defines the route helper methods" do
    expect((ctrlr.methods - Class.new.methods)).to include(:user_index_path)
    expect((ctrlr.methods - Class.new.methods)).to include(:user_show_path)
    expect((ctrlr.methods - Class.new.methods)).to include(:user_index_url)
    expect((ctrlr.methods - Class.new.methods)).to include(:user_show_url)
  end

  describe "url helper methods" do
    it "can calculate the url with no params" do
      expect(ctrlr.user_index_url).to eq("http://localhost/users")
    end
    
    it "can calculate the url with params" do
      expect(ctrlr.user_show_url(id: 5)).to eq("http://localhost/users/5")
    end
    
    it "can calculate the url with an object" do
      expect(ctrlr.user_show_url(user)).to eq("http://localhost/users/#{user_id}")
    end
  end

  describe "path helper methods" do
    it "can calculate the path with no params" do
      expect(ctrlr.user_index_path).to eq("/users")
    end
    
    it "can calculate the path with params" do
      expect(ctrlr.user_show_path(id: 5)).to eq("/users/5")
    end
    
    it "can calculate the path with an object" do
      expect(ctrlr.user_show_path(user)).to eq("/users/#{user_id}")
    end
  end
end
