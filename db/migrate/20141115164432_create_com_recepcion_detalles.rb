class CreateComRecepcionDetalles < ActiveRecord::Migration
    def change
        create_table :com_recepcion_detalles do |t|
            t.integer :IdCompra
            t.integer :IdProducto
            t.integer :Cantidad
            t.integer :Bultos
            t.float :Costo_Unitario
            t.float :Desc_Unitario
            t.float :Desc_Total
            t.float :Costo_Total
            t.float :Impuesto_Total
            t.float :Importe_Total
            t.boolean :Exento

            # t.timestamps
        end
    end
end
