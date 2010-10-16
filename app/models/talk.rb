class Talk < ActiveRecord::Base
  validates :title, :presence => true, :length => {:within => 5..300}
end
