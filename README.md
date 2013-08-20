# Curate

## Application Status

[![Build Status](https://travis-ci.org/ndlib/curate.png)](https://travis-ci.org/ndlib/curate)

## Installation

* Add `gem 'curate'` to your Gemfile, then run `bundle`
* Run the blacklight generator `rails generate blacklight --devise`
* Run the hydra-head generator `rails generate hydra:head -f`
* Run the sufia-models generator `rails generate sufia:models:install`
* Run the generator: `rails generate curate`
* Run the migrations `rake db:migrate`


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

=======
