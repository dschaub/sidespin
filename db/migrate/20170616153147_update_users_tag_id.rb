class UpdateUsersTagId < ActiveRecord::Migration[5.1]
  def change
    ken = User.find_by_email('ken@betterment.com')
    dan = User.find_by_email('dan.s@betterment.com')

    ken.try(:update, tag_id: '42D9CC0B')
    dan.try(:update, tag_id: '1BEB4949')
  end
end
