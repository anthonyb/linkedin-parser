class AddProfileIdAndSkillsToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :linkedin_profile_id, :string
    add_column :profiles, :skills, :text
    add_index :profiles, :linkedin_profile_id
  end
end
