class AddTypeToChampion < ActiveRecord::Migration
  def change
    add_column :champions, :types, :string, :default => ""
  end
end
