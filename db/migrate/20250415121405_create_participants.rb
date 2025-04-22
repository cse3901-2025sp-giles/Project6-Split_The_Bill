class CreateParticipants < ActiveRecord::Migration[7.2]
  def change
    create_table :participants do |t|
      t.string :name
      t.string :email
      t.references :trip, null: false, foreign_key: true

      t.timestamps
    end
  end
end
