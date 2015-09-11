class CreateClienteCarteras < ActiveRecord::Migration
    def change
        create_table :cliente_carteras do |t|
            t.integer :IdCliente
            t.integer :IdDocumento
            t.date :Fecha
            t.time :Hora
            t.string :Realiza
            t.string :Autoriza
            t.float :Monto
            t.string :Forma_pago
            t.string :Referencia

            # t.timestamps
        end
    end
end
