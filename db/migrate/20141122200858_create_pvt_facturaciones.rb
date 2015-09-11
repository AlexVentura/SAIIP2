class CreatePvtFacturaciones < ActiveRecord::Migration
  def change
    create_table :pvt_facturaciones do |t|
      t.integer :IdVenta
      t.integer :IdCaja
      t.integer :Fac_Tipo
      t.integer :Fac_Cajero
      t.integer :Fac_Vendedor
      t.integer :Cliente
      t.date :Fecha
      t.time :Hora
      t.string :Status
      t.float :Efectivo
      t.float :Tarjeta
      t.float :Cheque
      t.float :Vales
      t.float :Cupones
      t.integer :Motivo
      t.integer :Apertura

      # t.timestamps
    end
  end
end
