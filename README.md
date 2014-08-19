# Curate  [![Version](https://badge.fury.io/rb/curate.png)](http://badge.fury.io/rb/curate) [![Build Status](https://travis-ci.org/ndlib/curate.png?branch=master)](https://travis-ci.org/ndlib/curate) [![Coverage Status](https://coveralls.io/repos/ndlib/curate/badge.png)](https://coveralls.io/r/ndlib/curate)

Curate is a [Rails engine](http://edgeguides.rubyonrails.org/engines.html) leveraging [ProjectHydra](http://projecthydra.org) and [ProjectBlacklight](http://projectblacklight.org/) components to deliver a foundation for an Institutional Repositories.
It is released under the [Apache 2 License](./LICENSE)

* [Starting a new Curate-based Rails application](#starting-a-new-curate-based-application)
  * [or install by hand](#or-install-by-hand)
* [Developing and contributing for the Curate gem](#developing-and-contributing-for-the-curate-gem)
  * [Prerequisites](#prerequisites)
  * [Clone the Curate repository](#clone-the-curate-repository)
  * [Jetty](#jetty)
  * [Running the specs](#running-the-specs)
    * [All of them](#all-of-them)
    * [Some of them](#some-of-them)
    * [With Zeus](#with-zeus)
  * [Contributing back](#contributing-back)
* [Working on Curate while working on my Application](#working-on-curate-while-working-on-my-application)
* [Integration with CAS, LDAP, Shibboleth](#integration-with-cas-ldap-shibboleth)
* [Standing up your Curate-based Rails application in Production](#standing-up-your-curate-based-rails-application-in-production)

# Starting a New Curate Based Application

When you generate your new Rails application, you can use Curate's application template:
```bash
$ rails new my_curate_application -m https://raw.github.com/projecthydra/curate/master/lib/generators/curate/application_template.rb
```

## Or Install By Hand

Add the following line to your application's Gemfile:

    gem 'curate'

And then execute:
```bash
$ bundle
$ rails generate curate
```

# Developing and Contributing for the Curate gem

## Prerequisites

You may need to have the following installed ‡

* imagemagick (http://www.imagemagick.org/script/index.php)
* fits.sh (https://code.google.com/p/fits/wiki/installing)
* ffmpeg (optional, http://www.ffmpeg.org/)
* Redis (http://redis.io/)
* rubygems (http://rubygems.org/pages/download)
* ClamAV (http://www.clamav.net/)

‡ - Why "you may need"? Some of these are only optionally used in development and tests; But production will need it.

## Clone the Curate repository

From the command line:
```bash
git clone https://github.com/projecthydra/curate.git ./path/to/local
```

## Jetty

Curate uses Jetty for development and testing.
You could configure it to use an alternate Fedora and SOLR location, but that is an exercise for the reader.
**The hydra-jetty package should not be use for secure production installations**

### Install Jetty
Install jetty, you should only need to do this once (unless you remove the ./jetty directory)

```bash
$ rake jetty:unzip
```

## Running the Specs

Inside the Curate directory (i.e. `./path/to/local`):

### All of Them

1. Make sure jetty is running (`rake jetty:start`); It will take a bit to spin up jetty.
1. Make sure you have a dummy app ‡
  1. Run `rake regenerate` to build a clean app in ./spec/dummy
1. Then run `rake spec`; The tests will take quite a while ‡‡

‡ - A Rails engine requires a Rails application to run.
The dummy app is a generated application inside Curate in the `./spec/internal` directory
‡‡ - Slow tests are a big problem and we are working on speeding them up, but its complicated.

### Some of Them

In some cases you want to know the results of a single test. Here's how you do it.

1. Make sure jetty is running (`rake jetty:start`); It will take a bit to spin up jetty.
1. Make sure you have a dummy app ‡
  1. Run `rake regenerate` to build a clean app in ./spec/dummy
1. Then run `BUNDLE_GEMFILE=spec/internal/Gemfile bundle exec rspec path/to/spec.rb:LINE` ‡

‡ - With Curate being an Engine we need to point to the Dummy Application's Gemfile.
In full Rails applications you can normally run the following `rspec path/to/spec.rb:LINE`

### With Zeus

> [Zeus](https://github.com/burke/zeus) pre-loads your Rails app so that your normal development tasks such as console, server, generate, and specs/tests take less than one second. ‡

1. In terminal window #1 run `zeus start`
1. In terminal window #2, once Zeus is started: run `zeus rake spec` for all tests; or `zeus test path/to/spec.rb:LINE` for one

‡ - Loading the environment to run your tests takes less than a second. So running an individual test will take less time.

## Contributing Back

If you are interested in helping us make Curate better, please take a look at our [Contributing resources and guidelines](./CONTRIBUTING.md).

# Working on Curate while working on my Application

Assuming you are wanting to work on your Curate-based application and make modifications to the Curate gem, follow these instructions.

Replace the following line in the Gemfile of your Curate-based application (see [Starting a New Curate Based Application](#starting-a-new-curate-based-application)):

```ruby
gem 'curate' ...
```

with

```ruby
gem 'curate', path: './path/to/my/clone/of/curate'
```

[More information about Gemfile management at Bundler.io](http://bundler.io/v1.5/gemfile.html)

You can then do concurrent development on both your clone of the Curate gem and your Curate-based application.

**NOTE: Any changes you make in the Curate gem will likely require you to restart your web-server.**

# Integration with CAS, LDAP, Shibboleth

For integration with CAS, refer: https://github.com/nbudin/devise_cas_authenticatable

For integration with LDAP, refer: https://github.com/cschiewek/devise_ldap_authenticatable

For integration with Shibboleth, refer: https://github.com/jgeorge300/devise_shibboleth_authenticatable

For integration with multiple authentication systems (and for twitter, facebook, etc.), consider using OmniAuth: https://github.com/intridea/omniauth
