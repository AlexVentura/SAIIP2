class CreateComRecepciones < ActiveRecord::Migration
    def change
        create_table :com_recepciones do |t|
            t.integer :Id_MainTipo
            t.integer :IdProveedor
            t.string :Aplica
            t.date :Fecha
            t.time :Hora
            t.string :TipoCompra
            t.integer :Plazo
            t.string :Observaciones
            t.string :Referencia
            t.string :Status

            # t.timestamps
        end
    end
end
