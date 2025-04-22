class CreateExpenses < ActiveRecord::Migration[7.2]
  def change
    create_table :expenses do |t|
      t.string :description
      t.decimal :amount
      t.date :date
      t.string :payer_name
      t.references :trip, null: false, foreign_key: true

      t.timestamps
    end
  end
end
