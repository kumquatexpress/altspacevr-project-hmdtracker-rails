require 'test_helper'

class HmdsControllerTest < ActionController::TestCase
  test "should update existing hmd and return to index" do
    actual = hmds(:test)
    states = actual.hmd_states.count

    put :update, id: actual.id, hmd: {name: "testhmd", company: "altspace", state: "released",
    announced_at: DateTime.new(2015, 1, 2),
    image_url: "http://fakeurltest.com" }

    assert_response 302
    assert actual.hmd_states.count == states + 1
    assert actual.state == :released

    assert_redirected_to controller: "hmds", action: "index"
  end

  test "should get index with all hmds" do
    get :index, format: :json

    assert_response :success
    assert JSON.parse(response.body).count == Hmd.count
  end
end
