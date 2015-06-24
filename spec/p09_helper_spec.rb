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
    
    it "can calculate the url with a params" do
      expect(ctrlr.user_show_url(id: 1)).to eq("http://localhost/users/1")
    end
    
    it "can calculate the url with an object" do
      expect(ctrlr.user_show_url(user)).to eq("http://localhost/users/#{user_id}")
    end
  end

  # describe "#add_route" do
  #   it "adds a route" do
  #     subject.add_route(1, 2, 3, 4)
  #     expect(subject.routes.count).to eq(1)
  #     subject.add_route(1, 2, 3, 4)
  #     subject.add_route(1, 2, 3, 4)
  #     expect(subject.routes.count).to eq(3)
  #   end
  # end

  # describe "#match" do
  #   it "matches a correct route" do
  #     subject.add_route(Regexp.new("^/users$"), :get, :x, :x)
  #     allow(req).to receive(:path) { "/users" }
  #     allow(req).to receive(:request_method) { :get }
  #     matched = subject.match(req)
  #     expect(matched).not_to be_nil
  #   end

  #   it "doesn't match an incorrect route" do
  #     subject.add_route(Regexp.new("^/users$"), :get, :x, :x)
  #     allow(req).to receive(:path) { "/incorrect_path" }
  #     allow(req).to receive(:request_method) { :get }
  #     matched = subject.match(req)
  #     expect(matched).to be_nil
  #   end
  # end

  # describe "#run" do
  #   it "sets status to 404 if no route is found" do
  #     subject.add_route(Regexp.new("^/users$"), :get, :x, :x)
  #     allow(req).to receive(:path).and_return("/incorrect_path")
  #     allow(req).to receive(:request_method).and_return("GET")
  #     subject.run(req, res)
  #     expect(res.status).to eq(404)
  #   end
  # end

  # describe "http method (get, put, post, delete)" do
  #   it "adds methods get, put, post and delete" do
  #     router = Phase6::Router.new
  #     expect((router.methods - Class.new.methods)).to include(:get)
  #     expect((router.methods - Class.new.methods)).to include(:put)
  #     expect((router.methods - Class.new.methods)).to include(:post)
  #     expect((router.methods - Class.new.methods)).to include(:delete)
  #   end

  #   it "adds a route when an http method method is called" do
  #     router = Phase6::Router.new
  #     router.get Regexp.new("^/users$"), Phase6::ControllerBase, :index
  #     expect(router.routes.count).to eq(1)
  #   end
  # end
end
