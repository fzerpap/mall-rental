class RemoveMallFromCuentaBancaria < ActiveRecord::Migration
  def change
    remove_column :cuenta_bancaria, :mall_id, :int
  end
end
