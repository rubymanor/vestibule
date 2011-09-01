Factory.define(:user) do |f|
  f.signup_reason "I want to get involved with the content of the conference day"
  f.name "Alice"
  f.twitter_uid "123456"
  f.twitter_nickname "a_dawg"
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