class CreateChampions < ActiveRecord::Migration
  def change
    create_table :champions, id: false do |t|
      t.string :id
      t.string :image
      t.string :name

      t.timestamps
    end

    execute "ALTER TABLE champions ADD PRIMARY KEY (id);"
  end
end
