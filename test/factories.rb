Factory.define(:user) do |f|
  f.signup_reason "I want to get involved with the content of the conference day"
  f.name { Faker::Name.name }
  f.sequence(:twitter_uid) { |n| "#{n}123456" }
  f.twitter_nickname { Faker::Lorem.words(2).join('_') }
end

Factory.define(:proposal) do |f|
  f.sequence(:title) { |n| Faker::Lorem.sentence + " #{n}" }
  f.association :proposer, :factory => :user
end

Factory.define(:suggestion) do |f|
  f.association :proposal
  f.association :author, :factory => :user
  f.body { Faker::Lorem.paragraph }
end