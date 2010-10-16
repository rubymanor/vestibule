Factory.define :talk do |t|
  t.sequence :title do |n|
    "Talk ##{n}"
  end
end