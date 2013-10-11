# Curate  [![Version](https://badge.fury.io/rb/curate.png)](http://badge.fury.io/rb/curate) [![Build Status](https://travis-ci.org/ndlib/curate.png?branch=master)](https://travis-ci.org/ndlib/curate) [![Dependency Status](https://gemnasium.com/ndlib/curate.png)](https://gemnasium.com/ndlib/curate)

## Installation

* Add `gem 'curate'` to your Gemfile, then run `bundle`
* Run the generator: `rails generate curate`
* Run the following: `rails generate curate:work -h`; You may want to see how to create and register new works.

## Curate Developer Notes

### Initial Setup

* Install imagemagick (or else you will get errors when Bundler tries to compile rmagick)

### Jetty Commands

Install jetty:

        rake jetty:unzip

Start/stop jetty:

        rake jetty:start
        rake jetty:stop

Jetty logs:

        tail -f jetty/jettywrapper.log

### Running the Specs

To clean & generate a dummy app that the specs will use for testing:

        rake clean
        rake generate

Make sure jetty is running before you run the specs.

To run the test suite:

        rake spec

To run a localized spec:

        BUNDLE_GEMFILE=spec/internal/Gemfile bundle exec rspec path/to/spec.rb:LINE

### Running a copy of Curate in the curate gem

Given that Curate regenerates (via the `rake clean generate` tasks) you can run a functioning instance of curate in that directory.

From the curate directory:

        rake clean generate
        rake jetty:start
        cd ./spec/internal
        rails server
