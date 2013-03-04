#!/usr/bin/env bash

# Invoked by the CurateND-Integration Jenkins project
# Setup and run capistrano to deploy the preproduction application and workers
#
# This runs on the same host and jenkins
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

export RAILS_GROUP=deploy
echo "=-=-=-=-=-=-=-= bundle install"
#/shared/ruby_prod/ruby/1.9.3/bin/bundle install --path="$WORKSPACE/vendor/bundle" --binstubs="$WORKSPACE/vendor/bundle/bin" --shebang '/shared/ruby_prod/ruby/1.9.3/bin/ruby' --deployment --without production pre_production development test ci assets --gemfile="$WORKSPACE/Gemfile"
/shared/ruby_prod/ruby/1.9.3/bin/bundle install --path="$WORKSPACE/vendor/bundle" --binstubs="$WORKSPACE/vendor/bundle/bin" --shebang '/shared/ruby_prod/ruby/1.9.3/bin/ruby' --deployment --without default --gemfile="$WORKSPACE/Gemfile"

echo "=-=-=-=-=-=-=-= cd $WORKSPACE"
cd $WORKSPACE

# if [ -d secret_pprd ]; then
#     echo "=-=-=-=-=-=-=-= delete secret_pprd"
#     rm -rf secret_pprd
# fi
# echo "=-=-=-=-=-=-=-= git clone secret_pprd"
# git clone git@git.library.nd.edu:secret_pprd
#
# for f in database.yml solr.yml fedora.yml redis.yml; do
#     echo "=-=-=-=-=-=-=-= copy $f"
#     cp secret_pprd/curate_nd/$f config/$f
# done
#
echo "=-=-=-=-=-=-=-= cap pre_production deploy"
$WORKSPACE/vendor/bundle/bin/cap -v -f "$WORKSPACE/Capfile" pre_production deploy
retval=$?

echo "=-=-=-=-=-=-=-= $0 finished $retval"
if [ $retval -ne 0 ]; then
    echo "=-=-=-=-=-=-=-= Quitting because of error"
    exit $retval
fi

# always run deploy:setup, so if a new vm is added to the list, it will
# be prepared for a deploy automatically
echo "=-=-=-=-=-=-=-= cap staging_worker deploy:setup deploy"
$WORKSPACE/vendor/bundle/bin/cap -v -f "$WORKSPACE/Capfile" staging_worker deploy:setup deploy
retval=$?

echo "=-=-=-=-=-=-=-= $0 finished $retval"
exit $retval
