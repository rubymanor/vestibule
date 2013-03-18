desc "Alias to `heroku:deploy:head`"
task :release => 'heroku:deploy:head'

namespace :heroku do
  desc "Migrate DB on the live system"
  task :migrate do
    `heroku run rake db:migrate`
  end

  namespace :deploy do
    desc "Deploy to heroku from current HEAD"
    task :head do
      `git push heroku HEAD:master #{ENV['FORCE'] == 'true' ? '--force' : ''}`
    end
  end
end

