class AddTierToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :tier, :string, :default => "none"
  end
end
