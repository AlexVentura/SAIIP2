# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141122201529) do

  create_table "cliente_carteras", force: true do |t|
    t.integer "IdCliente"
    t.integer "IdDocumento"
    t.date    "Fecha"
    t.time    "Hora"
    t.string  "Realiza"
    t.string  "Autoriza"
    t.float   "Monto",       limit: 24
    t.string  "Forma_pago"
    t.string  "Referencia"
  end

  create_table "clientes", force: true do |t|
    t.string   "Nombre"
    t.string   "Direccion"
    t.string   "Ciudad"
    t.string   "Estado"
    t.string   "CP"
    t.string   "Telefono"
    t.string   "RFC"
    t.string   "TCuenta"
    t.integer  "Plazo"
    t.float    "Limite",     limit: 24
    t.string   "Status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "com_recepcion_detalles", force: true do |t|
    t.integer "IdCompra"
    t.integer "IdProducto"
    t.integer "Cantidad"
    t.integer "Bultos"
    t.float   "Costo_Unitario", limit: 24
    t.float   "Desc_Unitario",  limit: 24
    t.float   "Desc_Total",     limit: 24
    t.float   "Costo_Total",    limit: 24
    t.float   "Impuesto_Total", limit: 24
    t.float   "Importe_Total",  limit: 24
    t.boolean "Exento"
  end

  create_table "com_recepciones", force: true do |t|
    t.integer "Id_MainTipo"
    t.integer "IdProveedor"
    t.string  "Aplica"
    t.date    "Fecha"
    t.time    "Hora"
    t.string  "TipoCompra"
    t.integer "Plazo"
    t.string  "Observaciones"
    t.string  "Referencia"
    t.string  "Status"
  end

  create_table "proveedor_carteras", force: true do |t|
    t.integer "IdProveedor"
    t.integer "IdDocumento"
    t.date    "Fecha"
    t.time    "Hora"
    t.string  "Realiza"
    t.string  "Autoriza"
    t.float   "Monto",       limit: 24
    t.string  "Forma_Pago"
    t.string  "Referencia"
  end

  create_table "proveedores", force: true do |t|
    t.string   "Nombre"
    t.string   "Direccion"
    t.string   "Ciudad"
    t.string   "Estado"
    t.string   "CP"
    t.string   "Telefono"
    t.string   "RFC"
    t.string   "TCuenta"
    t.integer  "Plazo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pvt_facturacion_detalles", force: true do |t|
    t.integer "IdVenta"
    t.integer "IdCaja"
    t.integer "IdProducto"
    t.integer "Cantidad"
    t.float   "Precio_Unitario", limit: 24
    t.float   "Desc_Unitario",   limit: 24
    t.float   "Desc_Total",      limit: 24
    t.float   "Costo_Total",     limit: 24
    t.float   "Impuesto_Total",  limit: 24
    t.float   "Importe_Total",   limit: 24
    t.boolean "Exento"
  end

  create_table "pvt_facturaciones", force: true do |t|
    t.integer "IdVenta"
    t.integer "IdCaja"
    t.integer "Fac_Tipo"
    t.integer "Fac_Cajero"
    t.integer "Fac_Vendedor"
    t.integer "Cliente"
    t.date    "Fecha"
    t.time    "Hora"
    t.string  "Status"
    t.float   "Efectivo",     limit: 24
    t.float   "Tarjeta",      limit: 24
    t.float   "Cheque",       limit: 24
    t.float   "Vales",        limit: 24
    t.float   "Cupones",      limit: 24
    t.integer "Motivo"
    t.integer "Apertura"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
