class CreateProveedorCarteras < ActiveRecord::Migration
    def change
        create_table :proveedor_carteras do |t|
            t.integer :IdProveedor
            t.integer :IdDocumento
            t.date :Fecha
            t.time :Hora
            t.string :Realiza
            t.string :Autoriza
            t.float :Monto
            t.string :Forma_Pago
            t.string :Referencia

            # t.timestamps
        end
    end
end
