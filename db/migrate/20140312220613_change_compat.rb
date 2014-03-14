class ChangeCompat < ActiveRecord::Migration
  def change
    change_table :compatibilities do |t|
        t.change :compat, :string, {:default => {}.to_yaml, :limit => 5000}
    end
  end
end
