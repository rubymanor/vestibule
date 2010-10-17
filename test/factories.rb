Factory.define :talk do |t|
  t.sequence :title do |n|
    "Talk ##{n}"
  end
end

Factory.define(:user) do |f|
  f.email { Faker::Internet.email }
  f.password "letmein"
  f.password_confirmation "letmein"
  f.confirmed_at { Time.now }
end