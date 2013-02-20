#!/usr/bin/env bash

# Invoked by the CurateND-Integration Jenkins project
# Run the continuous integration tests
#
# called from Jenkins command
#       Build -> Execute Shell Command ==
#       test -x $WORKSPACE/script/jenkins_build.sh && $WORKSPACE/script/jenkins_build.sh
echo "=-=-=-=-=-=-=-= start $0"
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8

export PATH=/shared/git/bin:$PATH

echo "=-=-=-=-=-=-=-= bundle install"
/shared/ruby_prod/ruby/1.9.3/bin/bundle install --path="$WORKSPACE/vendor/bundle" --binstubs="$WORKSPACE/vendor/bundle/bin" --shebang '/shared/ruby_prod/ruby/1.9.3/bin/ruby' --deployment --gemfile="$WORKSPACE/Gemfile"

echo "=-=-=-=-=-=-=-= cd $WORKSPACE"
cd $WORKSPACE

if [ -d secret_ci ]; then
    echo "=-=-=-=-=-=-=-= delete secret_ci"
    rm -rf secret_ci
fi
echo "=-=-=-=-=-=-=-= git clone secret_ci"
git clone git@git.library.nd.edu:secret_ci

for f in database.yml solr.yml fedora.yml; do
    echo "=-=-=-=-=-=-=-= copy $f"
    cp secret_ci/curate_nd/$f config/$f
done

export RAILS_ENV=test
export HEADLESS=true

echo "=-=-=-=-=-=-=-= rake curatend:ci"
$WORKSPACE/vendor/bundle/bin/rake --trace curatend:ci
retval=$?

echo "=-=-=-=-=-=-=-= $0 finished $retval"
exit $retval
