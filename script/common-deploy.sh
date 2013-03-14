#!/usr/bin/env bash

# Setup and run capistrano to deploy the preproduction application and workers
#
# This runs on the same host as jenkins
#
# called from Jenkins command
#       Build -> Execute Shell Command ==
#       test -x $WORKSPACE/script/deploy-preproduction.sh && $WORKSPACE/script/deploy-preproduction.sh

function do_deploy() {
    local target_env=$1
    echo "=-=-=-=-=-=-=-= in do_deploy" "$@"
    if [ -z $target_env ]; then
        echo "=-=-=-=-=-=-=-= parameter missing"
        echo "Exiting do_deploy"
        return 1
    fi
    echo "=-=-=-=-=-=-=-= environment $target_env"
    LANG=en_US.UTF-8
    LC_ALL=en_US.UTF-8

    export PATH=/shared/git/bin:$PATH
    export PATH=/global/soft/fits/current:/shared/fedora_prod36/java/bin:$PATH
    export RAILS_ENV=$target_env

    # fetch capistrano
    echo "=-=-=-=-=-=-=-= bundle install"
    /shared/ruby_prod/ruby/1.9.3/bin/bundle install --path="$WORKSPACE/vendor/bundle" --binstubs="$WORKSPACE/vendor/bundle/bin" --shebang '/shared/ruby_prod/ruby/1.9.3/bin/ruby' --deployment --without development test assets not_deploy headless --gemfile="$WORKSPACE/Gemfile"

    echo "=-=-=-=-=-=-=-= cd $WORKSPACE"
    cd $WORKSPACE

    # it would be nice to simultaneously deploy to the cluster and the worker.
    # the `git` binaries on each host have different paths, but because of the
    # shared file mount, each can see the other's binaries.
    echo "=-=-=-=-=-=-=-= cap ${target_env}_cluster deploy"
    $WORKSPACE/vendor/bundle/bin/cap -v -f "$WORKSPACE/Capfile" ${target_env}_cluster deploy
    retval=$?

    echo "=-=-=-=-=-=-=-= finished $retval"
    if [ $retval -ne 0 ]; then
        echo "=-=-=-=-=-=-=-= Quitting because of error"
        return $retval
    fi

    # always run deploy:setup, so if a new vm is added to the list, it will
    # be prepared for a deploy automatically
    echo "=-=-=-=-=-=-=-= cap ${target_env}_worker deploy:setup deploy"
    $WORKSPACE/vendor/bundle/bin/cap -v -f "$WORKSPACE/Capfile" ${target_env}_worker deploy:setup deploy
    retval=$?

    echo "=-=-=-=-=-=-=-= do_deploy finished $retval"
    return $retval
}
