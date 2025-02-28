class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_amount
      t.string :status
      t.string :stripe_payment_id

      t.timestamps
    end
  end
end
