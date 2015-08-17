class AddMallToBancos < ActiveRecord::Migration
  def change
    add_column :bancos, :mall_id, :int
    add_index :bancos, :mall_id
  end
end
