require 'webrick'
require_relative '../lib/controller'

describe "flash feature" do
  before(:all) do
    class FlashCatsController < ControllerBase
      def now_index
        flash.now[:cat_flash] = "THIS IS THE CAT FLASH"
        @cats = ["GIZMO"]
      end

      def index
        flash[:cat_flash] = "THIS IS THE CAT FLASH"
        @cats = ["GIZMO"]
      end
    end
  end
  after(:all) { Object.send(:remove_const, "FlashCatsController") }

  let(:req) { WEBrick::HTTPRequest.new(Logger: nil) }
  let(:res) { WEBrick::HTTPResponse.new(HTTPVersion: '1.0') }
  let(:cats_controller) { FlashCatsController.new(req, res) }

  describe "flash" do
    it "passes the flash to the response in a cookie" do
      cats_controller.invoke_action(:index)

      # Does the flash cookie exist
      flash_cookie = cats_controller
        .res
        .cookies
        .find { |c| c.name == 'FLASH' }
      expect(flash_cookie).to be

      # Does the set value exist
      flash_hash = JSON.parse(flash_cookie.value) || {}
      expect(flash_hash['cat_flash']).to eq("THIS IS THE CAT FLASH")
    end

    it "can read the uploaded flash cookie" do
      req.cookies << WEBrick::Cookie.new("FLASH", {"cat_flash" => "THIS IS THE CAT FLASH"}.to_json)

      cats_controller.invoke_action(:index)
      expect(cats_controller.res.body).to include("THIS IS THE CAT FLASH")
    end

    it "renders the flash.now within the view" do
      cats_controller.invoke_action(:now_index)
      expect(cats_controller.res.body).to include("THIS IS THE CAT FLASH")
    end
  end
end
