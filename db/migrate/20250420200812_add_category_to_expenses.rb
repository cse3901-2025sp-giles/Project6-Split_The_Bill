class AddCategoryToExpenses < ActiveRecord::Migration[7.2]
  def change
    add_column :expenses, :category, :string
  end
end
