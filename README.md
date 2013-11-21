# Curate  [![Version](https://badge.fury.io/rb/curate.png)](http://badge.fury.io/rb/curate) [![Build Status](https://travis-ci.org/projecthydra/curate.png?branch=master)](https://travis-ci.org/projecthydra/curate) [![Coverage Status](https://coveralls.io/repos/projecthydra/curate/badge.png)](https://coveralls.io/r/projecthydra/curate)

## Starting a New Curate Base Application

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

## Curate Developer Notes

### Initial Setup

* Install imagemagick (or else you will get errors when Bundler tries to compile rmagick)

### Jetty Commands

Install jetty:

```bash
$ rake jetty:unzip
```

Start/stop jetty:

```bash
$ rake jetty:start
$ rake jetty:stop
```

Jetty logs:

```bash
$ tail -f jetty/jettywrapper.log
```

### Running the Specs

To clean & generate a dummy app that the specs will use for testing:
```bash
$ rake clean
$ rake generate
```

Make sure jetty is running before you run the specs.

To run the test suite:
```bash
$ rake spec
```

To run a localized spec:
```bash
$ BUNDLE_GEMFILE=spec/internal/Gemfile bundle exec rspec path/to/spec.rb:LINE
```

#### Or run via Zeus:

In terminal window #1
```bash
$ zeus start
```

In terminal window #2, once Zeus is loaded:

```bash
$ zeus rake spec
```

Or a localized spec:

```bash
$ zeus test path/to/spec.rb:LINE
```

### Running a copy of Curate in the curate gem

Given that Curate regenerates (via the `rake clean generate` tasks) you can run a functioning instance of curate in that directory.

From the curate directory:
```bash
$ rake clean generate
$ rake jetty:start
$ cd ./spec/internal
$ rails server
```
