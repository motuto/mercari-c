class AddSizeIdToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :size_id, :integer, null: false
  end
end
