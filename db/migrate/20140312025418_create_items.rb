class CreateItems < ActiveRecord::Migration
  def change
    create_table :items, id: false do |t|
      t.string :id
      t.string :name
      t.string :image

      t.timestamps
    end

    execute "ALTER TABLE items ADD PRIMARY KEY (id);"
  end
end
