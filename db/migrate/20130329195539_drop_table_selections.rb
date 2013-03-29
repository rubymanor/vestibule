class DropTableSelections < ActiveRecord::Migration
  def change
    drop_table :selections
  end
end
