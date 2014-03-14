class CreateTeamComps < ActiveRecord::Migration
  def change
    create_table :team_comps, id: false do |t|
      t.string :id

      t.integer :c1
      t.integer :c2
      t.integer :c3
      t.integer :c4
      t.integer :c5
      t.timestamps
    end

    create_table :games_team_comps, id: false do |t|
      t.belongs_to :game, :limit => 8
      t.belongs_to :team_comp, :limit => 8
    end

    add_index :games_team_comps, :game_id, :name => 'game_id_ix'
    add_index :games_team_comps, :team_comp_id, :name => 'team_id_ix'  

  end
end
