Vestibule
=========

This is the simple application that we're using to build the CFP platfrom for [Euruko 2013][]. It's simple purpose is to collect talk proposals, and try to channel feedback and suggestions on those proposals into *useful forms*.

This app is build on top of [Ruby Manor 3][] [original Vestibule app][] and we thank them for that!

Getting started
-----------------

1. Setup a Postgres server. The simplest thing to do is to download the [Turnkey Postgres Appliance][] in the OVF format and run it with [VirtualBox][].
2. Copy config/database.example.yml to config/database.yml and update it appropriately
2. Copy config/application.example.yml to config/application.yml and customize it to fit your needs
3. Set the following environment variable: `COOKIE_SECRET` with a lengthy key
4. Run the tests: `rake`
5. Register the app for the "social login" thing. See section below for more info.
4. Start a server: `rails server`

You should be ready :)

Social login setup
-----------------

Github:

1. Go to settings/applications and add a new application
2. Set URL to whatever makes sense (for example `http://localhost:3000` if it's for your dev environement)
3. Set Callback URL to `<base_url>/auth/github/callback` (so for this example it would be `http://localhost:3000/auth/github/callback`)
4. Set the `GITHUB_KEY` and the `GITHUB_SECRET` to the `Client ID` and the `Client Secret` respectively
5. (Optional) Set these for heroku (after having completed the heroku setup) by running `heroku config:add GITHUB_KEY=<the Client ID>` and `heroku config:add GITHUB_SECRET=<the Client Secret>`

Deploying on Heroku (non official site)
-----------------

1. Sign up on [Heroku][]
2. Download the [Heroku toolbelt][]
3. Login from the command line: `heroku login`
4. Create your heroku app: `heroku create`
5. Add the New Relic add on (requires credit card information): `heroku addons:add newrelic:standard`
6. Switch to your own branch (or in EuRuKo 2013 case, the `euruko2013` branch) and un-ignore the `config/application.yml` since heroku needs this
7. Deploy: `git push heroku your-branch:master`
8. Check the app: `heroku open`

For more info, checkout the [official heroku guide][]

Deploying the official site
-----------------

Contact @nikosd

How to contribute
-----------------

Fork, patch, test, send a pull request. Branches should be based on `master` and not `euruko2013` with the exception of EuRuKo 2013 specific stuff.

Build Status
------------

[![Build Status](https://secure.travis-ci.org/euruko2013/vestibule.png)](http://travis-ci.org/euruko2013/vestibule)

[Euruko 2013]: http://euruko2013.org/
[Ruby Manor 3]: http://rubymanor.org/3
[original Vestibule app]: https://github.com/rubymanor/vestibule
[Turnkey Postgres Appliance]: http://www.turnkeylinux.org/postgresql
[VirtualBox]: https://www.virtualbox.org/
[Heroku]: http://www.heroku.com/
[Heroku toolbelt]: https://toolbelt.heroku.com/
[official heroku guide]: https://devcenter.heroku.com/articles/rails3