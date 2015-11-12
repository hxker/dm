class AddDistrictIdToUserProfiles < ActiveRecord::Migration
  def change
    add_column :user_profiles, :district_id, :integer
    add_index :user_profiles, :district_id
  end


end
