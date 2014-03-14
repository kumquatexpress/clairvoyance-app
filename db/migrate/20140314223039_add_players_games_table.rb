class AddPlayersGamesTable < ActiveRecord::Migration
  def change
    create_table :games_players, id: false do |t|
      t.belongs_to :game, :limit => 8
      t.belongs_to :player, :limit => 8
    end

    add_index :games_team_comps, :game_id, :name => 'game_id_ix'
    add_index :games_team_comps, :player_id, :name => 'player_id_ix'  
  end
end
