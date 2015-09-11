class CreateClientes < ActiveRecord::Migration
  def change
    create_table :clientes do |t|
      t.string :Nombre
      t.string :Direccion
      t.string :Ciudad
      t.string :Estado
      t.string :CP
      t.string :Telefono
      t.string :RFC
      t.string :TCuenta
      t.integer :Plazo
      t.float :Limite
      t.string :Status

      t.timestamps
    end
  end
end
