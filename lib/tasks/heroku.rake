namespace :heroku do
  namespace :deploy do
    desc "Deploy to heroku from current HEAD"
    task :head do
      `git push heroku HEAD:master #{ENV['FORCE'] == 'true' ? '--force' : ''}`
    end
  end
end

