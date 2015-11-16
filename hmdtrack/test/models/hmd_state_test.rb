require 'test_helper'

class HmdStateTest < ActiveSupport::TestCase
  test "belongs to an hmd" do
    actual = hmd_states(:old).hmd
    expected = hmds(:test)
    assert actual == expected
  end

  test "does not respond to overridden state= and state" do
    subject = hmd_states(:old)
    actual = "asdf"
    subject.state = "asdf"
    assert subject.state == actual
    assert subject.save!
  end
end
