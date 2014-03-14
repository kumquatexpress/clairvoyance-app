class CreateCompatibilities < ActiveRecord::Migration
  def change
    create_table :compatibilities, id: false do |t|
      t.integer :id
      t.integer :champion_id
      t.string :compat, :default => {}.to_yaml, :limit => 5000
      t.timestamps
    end

    add_column :champions, :compatibility_id, :integer

    execute "ALTER TABLE compatibilities ADD PRIMARY KEY (id);"
  end
end
