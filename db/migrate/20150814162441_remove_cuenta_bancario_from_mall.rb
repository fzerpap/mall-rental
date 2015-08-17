class RemoveCuentaBancarioFromMall < ActiveRecord::Migration
  def change
    remove_column :malls, :cuenta_bancarium_id, :int
  end
end
