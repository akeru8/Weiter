class AddUsersaddToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    change_column :users, :name, :string, null:false
    add_column :users, :introduction, :text
    add_column :users, :goal, :string
    add_column :users, :profile_image_id, :string
  end
end
