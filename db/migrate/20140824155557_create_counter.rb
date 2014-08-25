class CreateCounter < ActiveRecord::Migration
  def change
    create_table :counters do |t|
      t.string :countable
      t.integer :total
    end
  end
end
