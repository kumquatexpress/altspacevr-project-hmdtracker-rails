class AddIndexToHmdStates < ActiveRecord::Migration
  def change
    add_index :hmd_states, :updated_at
    add_index :hmd_states, :hmd_id
  end
end
