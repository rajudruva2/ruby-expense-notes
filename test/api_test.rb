require "minitest/autorun"
require "rack/test"
require_relative "../app"

class ApiTest < Minitest::Test
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end

  def test_health
    get "/health"
    assert_equal 200, last_response.status
    assert_equal "ok", JSON.parse(last_response.body)["status"]
  end

  def test_list
    get "/expenses"
    assert_equal 200, last_response.status
    assert_kind_of Array, JSON.parse(last_response.body)
  end
end
