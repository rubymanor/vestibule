class Agenda < ActiveRecord::Base
  belongs_to :user
  has_many :agenda_items
  has_many :proposals, through: :agenda_items, order: "agenda_items.rank"
end
