Vestibule
=========

This is the simple application that we're using to build the CFP platfrom for [Euruko 2013][]. It's simple purpose is to collect talk proposals, and try to channel feedback and suggestions on those proposals into *useful forms*.

This app is build on top of [Ruby Manor 3][] [original Vestibule app][] and we thank them for that!

Getting started
-----------------

1. Setup a Postgres server. The simplest thing to do is to download the [Turnkey Postgres Appliance][] in the OVF format and run it with [VirtualBox][].
2. Copy config/database.example.yml to config/database.yml and update it appropriately
3. Set the following environment variable: `COOKIE_SECRET` with a lengthy key
4. Run the tests: `rake`

You should be ready :)

How to contribute
-----------------

Fork, patch, test, send a pull request.

Deploying on Heroku (non official site)
-----------------

1. Sign up on [Heroku][]
2. Download the [Heroku toolbelt][]
3. Login from the command line: `heroku login`
4. Create your heroku app: `heroku create`
5. Add the New Relic add on (requires credit card information): `heroku addons:add newrelic:standard`
6. Deploy: `git push heroku master`
7. Check the app: `heroku open`

For more info, checkout the [official heroku guide][]

Deploying the official site
-----------------

Contact @nikosd

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