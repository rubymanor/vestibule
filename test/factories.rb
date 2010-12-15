Factory.define :talk do |t|
  t.sequence :title do |n|
    "Talk ##{n}"
  end
  t.association :suggester, :factory => :user
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

Factory.define :contribution do |c|
  c.association :talk
  c.association :user
  c.kind 'extra detail provide'
end

Factory.define :suggestion, :parent => :contribution do |s|
  s.kind 'suggest'
end

Factory.define :extra_detail_provision, :parent => :contribution do |edp|
  edp.kind 'extra detail provide'
end
