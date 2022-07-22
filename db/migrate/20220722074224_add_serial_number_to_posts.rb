class AddSerialNumberToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :serial_number, :string
  end
end
