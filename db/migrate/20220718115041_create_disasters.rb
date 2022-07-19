class CreateDisasters < ActiveRecord::Migration[6.1]
  def change
    create_table :disasters do |t|
      t.string :category
      t.timestamps
    end
  end
end
