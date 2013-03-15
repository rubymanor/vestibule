class AddConfirmedFlagToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :confirmed, :boolean, default: false, null: false
  end
end
