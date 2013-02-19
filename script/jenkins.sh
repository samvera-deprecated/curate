#!/usr/bin/env bash

# Invoked by the CurateND-Integration Jenkins project
# Run the continuous integration tests

# git path
export PATH=/shared/git/bin:$PATH

/shared/ruby_prod/ruby/1.9.3/bin/bundle install --path="$WORKSPACE/vendor/bundle" --binstubs="$WORKSPACE/vendor/bundle/bin" --shebang '/shared/ruby_prod/ruby/1.9.3/bin/ruby' --deployment --gemfile="$WORKSPACE/Gemfile"
cd $WORKSPACE

if [ -d secret_ci ]; then
    rm -rf secret_ci
fi
git clone git@git.library.nd.edu:secret_ci

for f in database.yml solr.yml fedora.yml; do
    cp secret_ci/curate_nd/$f config/$f
done

export RAILS_ENV=test

$WORKSPACE/vendor/bundle/bin/rake db:migrate db:test:prepare
