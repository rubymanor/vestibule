class CreateAgendas < ActiveRecord::Migration
  def self.up
    create_table :agendas do |t|
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :agendas
  end
end
