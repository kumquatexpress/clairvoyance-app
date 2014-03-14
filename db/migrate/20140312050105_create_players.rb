class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players, id: false do |t|
      t.string :name
      t.integer :id

      t.timestamps
    end

    execute "ALTER TABLE players ADD PRIMARY KEY (id);"
  end
end
