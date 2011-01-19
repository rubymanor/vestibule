Factory.define(:account) do |f|
  f.email { Faker::Internet.email }
  f.password "letmein"
  f.password_confirmation "letmein"
  f.confirmed_at { Time.now }
end

Factory.define(:user) do |f|
  f.signup_reason "I want to get involved with the content of the conference day"
  f.association :account
end

Factory.define(:proposal) do |f|
  f.title "My Wonderous Pontifications"
  f.association :proposer, :factory => :user
end
