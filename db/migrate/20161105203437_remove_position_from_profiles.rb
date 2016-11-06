class RemovePositionFromProfiles < ActiveRecord::Migration
  def change
    remove_column :profiles, :position
  end
end
