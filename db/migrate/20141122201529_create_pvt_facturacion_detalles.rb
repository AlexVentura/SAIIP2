class CreatePvtFacturacionDetalles < ActiveRecord::Migration
  def change
    create_table :pvt_facturacion_detalles do |t|
      t.integer :IdVenta
      t.integer :IdCaja
      t.integer :IdProducto
      t.integer :Cantidad
      t.float :Precio_Unitario
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
