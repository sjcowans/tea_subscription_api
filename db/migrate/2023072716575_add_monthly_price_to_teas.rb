class AddMonthlyPriceToTeas < ActiveRecord::Migration[7.0]
  def change
    add_column :teas, :monthly_price, :integer, default: 50
  end
end
