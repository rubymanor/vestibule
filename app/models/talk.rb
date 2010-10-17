class Talk < ActiveRecord::Base
  has_many :feedbacks

  validates :title, :presence => true, :length => {:within => 5..300}

  [:abstract, :outline, :why_its_interesting].each do |optional_text_attribute|
    validates optional_text_attribute, :length => {:minimum => 10, :allow_blank => true}
  end
end
