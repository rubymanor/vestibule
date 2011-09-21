class AgendaItem < ActiveRecord::Base
  belongs_to :agenda
  belongs_to :proposal
  belongs_to :user
end
