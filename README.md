# Curate  [![Version](https://badge.fury.io/rb/curate.png)](http://badge.fury.io/rb/curate) [![Build Status](https://travis-ci.org/projecthydra/curate.png?branch=master)](https://travis-ci.org/projecthydra/curate) [![Coverage Status](https://coveralls.io/repos/projecthydra/curate/badge.png)](https://coveralls.io/r/projecthydra/curate)

Curate is a [Rails engine](http://edgeguides.rubyonrails.org/engines.html) leveraging [ProjectHydra](http://projecthydra.org) and [ProjectBlacklight](http://projectblacklight.org/) components to deliver a foundation for an Institutional Repositories.
It is released under the [Apache 2 License](./LICENSE)

1. [Starting a new Curate-based Rails application](#starting-a-new-curate-based-application)
  1. [or install by hand](#or-install-by-hand)
1. [Developing and contributing back to the Curate gem](#developing-and-contributing-back-to-the-curate-gem)
  1. [Prerequisites](#prerequisites)
  1. [Clone the Curate repository](#clone-the-repo)
  1. [Jetty](#jetty)
  1. [Running the specs](#running-the-specs)
    1. [All of them](#all-of-them)
    1. [Some of them](#some-of-them)
    1. [With Zeus](#with-zeus)
  1. [Contributing back](#contributing-back)

## Starting a New Curate Based Application

When you generate your new Rails application, you can use Curate's application template:
```bash
$ rails new my_curate_application -m https://raw.github.com/ndlib/curate/master/lib/generators/curate/application_template.rb
```

### Or Install By Hand

Add the following line to your application's Gemfile:

    gem 'curate'

And then execute:
```bash
$ bundle
$ rails generate curate
```

## Developing and Contributing back to the Curate gem

### Prerequisites

You may need to have the following installed ‡

* imagemagick
* fits.sh
* ffmpeg
* Redis
* rubygems
* ClamAV

‡ - Why "you may need"? Some of these are only optionally used in development and tests; But production will need it.

### Clone the Curate repository

From the command line:
```bash
git clone https://github.com/projecthydra/curate.git ./path/to/local
```

### Jetty

Curate uses Jetty for development and testing.
You could configure it to use an alternate Fedora and SOLR location, but that is an exercise for the reader.

#### Install Jetty
Install jetty, you should only need to do this once (unless you remove the ./jetty directory)

```bash
$ rake jetty:unzip
```

### Running the Specs

Inside the Curate directory:

#### All of Them

1. Make sure jetty is running (`rake jetty:start`); It will take a bit to spin up jetty.
1. Make sure you have a dummy app ‡
  1. Run `rake regenerate` build the to get a clean app ./spec/dummy
1. Then run `rake spec`; The tests will take quite a while ‡‡

‡ - A Rails engine requires a Rails application to run.
The dummy app is an generated application inside Curate in the `./spec/internal` directory
‡‡ - Slow tests are a big problem and we are working on speeding them up, but its complicated.

#### Some of Them

In some cases you want to know the results of a single test. Here's how you do it.

1. Make sure jetty is running (`rake jetty:start`); It will take a bit to spin up jetty.
1. Make sure you have a dummy app ‡
  1. Run `rake regenerate` build the to get a clean app ./spec/dummy
1. Then run `BUNDLE_GEMFILE=spec/internal/Gemfile bundle exec rspec path/to/spec.rb:LINE` ‡

‡ - With Curate being an Engine we need to point to the Dummy Application's Gemfile.
In full Rails applications you can normally run the following `rspec path/to/spec.rb:LINE`

#### With Zeus

> [Zeus](https://github.com/burke/zeus) preloads your Rails app so that your normal development tasks such as console, server, generate, and specs/tests take less than one second. ‡

1. In terminal window #1 run `zeus start`
1. In terminal window #2, once Zeus is started: run `zeus rake spec` for all tests; or `zeus test path/to/spec.rb:LINE` for one

‡ - Loading the environment to run your tests takes less than a second. So running an individual test will take less time.

### Contributing Back

There is an existing [CONTRIBUTING.md](./CONTRIBUTING.md) document which is currently under review.
For now, follow those guidelines.
