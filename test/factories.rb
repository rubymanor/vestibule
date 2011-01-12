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

Factory.define(:account) do |f|
  f.signup_reason "I want to get involved with the content of the conference day"
end

Factory.define :feedback do |f|
  f.content { Faker::Lorem.paragraph }
  f.association :talk
  f.association :user
end
