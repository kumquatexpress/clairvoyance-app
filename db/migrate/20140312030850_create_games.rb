class CreateGames < ActiveRecord::Migration
  def change
    create_table :games, id: false do |t|
      t.integer :id, :limit => 8
      t.string :type
      t.datetime :date
      t.integer :win

      t.timestamps
    end

    create_table :champions_games, id: false do |t|
      t.belongs_to :game
      t.belongs_to :champion
    end

    create_table :games_items, id: false do |t|
      t.belongs_to :game
      t.belongs_to :item
    end

    add_index :champions_games, :champion_id, :name => 'champion_id_ix'
    add_index :champions_games, :game_id, :name => 'game_id_ix'

    add_index :games_items, :game_id, :name => 'game_id_ix'
    add_index :games_items, :item_id, :name => 'item_id_ix'

    execute "ALTER TABLE games ADD PRIMARY KEY (id);"

  end
end
