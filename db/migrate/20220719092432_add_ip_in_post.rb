class AddIpInPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :ip, :string
  end
end
