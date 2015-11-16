require 'test_helper'

class HmdInfoTest < ActiveSupport::TestCase
  test "has many hmd_states" do
    actual = hmds(:test).hmd_states
    expected = [hmd_states(:old), hmd_states(:new)]

    assert actual == expected
  end

  test "returns the most recent state when asked" do
    subject = hmds(:test)
    expected = HmdState.where(hmd_id: subject.id).order(updated_at: :desc).pluck(:state).first.to_sym

    assert subject.state == expected
  end

  test "assigns the correct new state by making a new hmdstate when given a symbol" do
    subject = hmds(:test)
    states = subject.hmd_states.count
    expected = :announced
    subject.state = :announced

    assert subject.state == expected
    assert subject.hmd_states.count == states + 1
  end

  test "assigns the correct new state by making a new hmdstate when given a string" do
    subject = hmds(:test)
    states = subject.hmd_states.count
    expected = :announced
    subject.state = "announced"

    assert subject.state == expected
    assert subject.hmd_states.count == states + 1
  end

  test "creates a new state when given the same state as current if no existing states" do
    subject = hmds(:updated)
    states = subject.hmd_states.count
    expected = subject.state
    subject.state = subject.state.to_sym

    assert states == 0
    assert subject.state == expected
    assert subject.hmd_states.count == states + 1
  end

  test "does not create a new state when given the same state if already existing" do
    subject = hmds(:test)
    states = subject.hmd_states.count
    expected = subject.state
    subject.state = subject.state.to_sym

    assert states == 2
    assert subject.state == expected
    assert subject.hmd_states.count == states
  end

  test "returns the first viable state by default if no state exists" do
    subject = hmds(:updated)
    expected = :announced

    assert subject.state == expected
    assert subject.hmd_states.count == 0
  end

  test "does not respond to overridden state= and state" do
    subject = hmd_states(:old)
    actual = "asdf"
    subject.state = "asdf"

    assert subject.state == actual
    assert subject.save!
  end
end
