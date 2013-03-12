#!/usr/bin/env bash

# Invoked by the CurateND-Integration Jenkins project
# Setup and run capistrano to deploy the preproduction application and workers
#
# This runs on the same host as jenkins
#
# called from Jenkins command
#       Build -> Execute Shell Command ==
#       test -x $WORKSPACE/script/deploy-preproduction.sh && $WORKSPACE/script/deploy-preproduction.sh
echo "=-=-=-=-=-=-=-= start $0"
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8

export PATH=/shared/git/bin:$PATH
export PATH=/global/soft/fits/current:/shared/fedora_prod36/java/bin:$PATH
export RAILS_ENV=pre_production

# fetch capistrano
echo "=-=-=-=-=-=-=-= bundle install"
/shared/ruby_prod/ruby/1.9.3/bin/bundle install --path="$WORKSPACE/vendor/bundle" --binstubs="$WORKSPACE/vendor/bundle/bin" --shebang '/shared/ruby_prod/ruby/1.9.3/bin/ruby' --deployment --without development test assets not_deploy headless --gemfile="$WORKSPACE/Gemfile"

echo "=-=-=-=-=-=-=-= cd $WORKSPACE"
cd $WORKSPACE

# it would be nice to simultaneously deploy to the cluster and the worker.
# the `git` binary have different paths on each host, but because of the shared file
# mount, each can see the other's binaries
echo "=-=-=-=-=-=-=-= cap pre_production deploy"
$WORKSPACE/vendor/bundle/bin/cap -v -f "$WORKSPACE/Capfile" pre_production_cluster deploy
retval=$?

echo "=-=-=-=-=-=-=-= $0 finished $retval"
if [ $retval -ne 0 ]; then
    echo "=-=-=-=-=-=-=-= Quitting because of error"
    exit $retval
fi

# always run deploy:setup, so if a new vm is added to the list, it will
# be prepared for a deploy automatically
echo "=-=-=-=-=-=-=-= cap preproduction_worker deploy:setup deploy"
$WORKSPACE/vendor/bundle/bin/cap -v -f "$WORKSPACE/Capfile" pre_production_worker deploy:setup deploy
retval=$?

echo "=-=-=-=-=-=-=-= $0 finished $retval"
exit $retval
