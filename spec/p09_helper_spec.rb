require 'webrick'
require 'phase6/router'
require 'phase9/controller_base'

describe Phase9::Router do
  let(:router) { Phase9::Router.new }
  let(:req) { WEBrick::HTTPRequest.new(Logger: nil) }
  let(:res) { WEBrick::HTTPResponse.new(HTTPVersion: '1.0') }
  let(:ctrlr) { UsersController.new(req, res) }
  let(:user) { double("user") }
  let(:user_id) { 7 }

  before(:each) do
    class UsersController < Phase9::ControllerBase
    end

    # Allowances
    allow(req).to receive(:host) { "localhost" }
    allow(user).to receive(:id) { user_id }

    router.add_route(Regexp.new("^/users$"), :get, UsersController, :index)
    router.add_route(Regexp.new("^/users$"), :post, UsersController, :create)
    router.add_route(Regexp.new("^/users/new$"), :get, UsersController, :new)
    router.add_route(Regexp.new("^/users/(?<id>\\d+)$"), :get, UsersController, :show)
    router.add_route(Regexp.new("^/users/(?<id>\\d+)$"), :get, UsersController, :update)
    router.add_route(Regexp.new("^/users/(?<id>\\d+)$"), :get, UsersController, :destroy)
    router.add_route(Regexp.new("^/users/(?<id>\\d+)/edit$"), :get, UsersController, :edit)

    UsersController.define_route_helpers(router.routes)
  end

  describe "path helper methods" do
    it "should include all of the path helper methods" do
      expect((ctrlr.methods - Class.new.methods)).to include(:users_path)
      expect((ctrlr.methods - Class.new.methods)).to include(:user_path)
      expect((ctrlr.methods - Class.new.methods)).to include(:edit_user_path)
      expect((ctrlr.methods - Class.new.methods)).to include(:new_user_path)
    end

    it "can calculate the path with no params" do
      expect(ctrlr.users_path).to eq("/users")
      expect(ctrlr.new_user_path).to eq("/users/new")
    end
    
    it "can calculate the path with params" do
      expect(ctrlr.user_path(id: 5)).to eq("/users/5")
    end
    
    it "can calculate the path with an object" do
      expect(ctrlr.edit_user_path(user)).to eq("/users/#{user_id}/edit")
    end
  end

  describe "url helper methods" do
    it "should include all of the helper methods" do
      expect((ctrlr.methods - Class.new.methods)).to include(:users_url)
      expect((ctrlr.methods - Class.new.methods)).to include(:user_url)
      expect((ctrlr.methods - Class.new.methods)).to include(:edit_user_url)
      expect((ctrlr.methods - Class.new.methods)).to include(:new_user_url)
    end

    it "can calculate urls with no params" do
      expect(ctrlr.users_url).to eq("http://localhost/users")
      expect(ctrlr.new_user_url).to eq("http://localhost/users/new")
    end
    
    it "can calculate the url with params" do
      expect(ctrlr.user_url(id: 5)).to eq("http://localhost/users/5")
    end
    
    it "can calculate the url with an object" do
      expect(ctrlr.edit_user_url(user)).to eq("http://localhost/users/#{user_id}/edit")
    end
  end
end
