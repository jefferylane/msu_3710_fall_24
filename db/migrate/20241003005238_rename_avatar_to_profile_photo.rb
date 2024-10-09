class RenameAvatarToProfilePhoto < ActiveRecord::Migration[7.1]
  def change
    rename_column :students, :avatar, :profile_photo
  end
end
