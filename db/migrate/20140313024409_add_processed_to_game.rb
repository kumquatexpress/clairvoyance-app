class AddProcessedToGame < ActiveRecord::Migration
  def change
    add_column :games, :processed, :boolean, :default => false
  end
end
