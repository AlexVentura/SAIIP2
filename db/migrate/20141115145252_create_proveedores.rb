class CreateProveedores < ActiveRecord::Migration
    def change
        create_table :proveedores do |t|
            t.string :Nombre
            t.string :Direccion
            t.string :Ciudad
            t.string :Estado
            t.string :CP
            t.string :Telefono
            t.string :RFC
            t.string :TCuenta
            t.integer :Plazo

            t.timestamps
        end
    end
end
