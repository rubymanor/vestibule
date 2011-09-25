class CreateAgendaItems < ActiveRecord::Migration
  def self.up
    create_table :agenda_items do |t|
      t.integer :agenda_id
      t.integer :proposal_id
      t.integer :rank
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :agenda_items
  end
end
