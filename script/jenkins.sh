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
export PATH=/global/soft/fits/current:/shared/fedora_prod36/java/bin:$PATH
export RAILS_ENV=ci
export HEADLESS=true

echo "=-=-=-=-=-=-=-= bundle install"
/shared/ruby_prod/ruby/1.9.3/bin/bundle install --path="$WORKSPACE/vendor/bundle" --binstubs="$WORKSPACE/vendor/bundle/bin" --shebang '/shared/ruby_prod/ruby/1.9.3/bin/ruby' --deployment --gemfile="$WORKSPACE/Gemfile"


echo "=-=-=-=-=-=-=-= cd $WORKSPACE"
cd $WORKSPACE

echo "=-=-=-=-=-=-=-= clamscan --version"
echo $(clamscan --version)

echo "=-=-=-=-=-=-=-= Removing files Jenkins does not like"
# A file in this directoy has a filename that Jenkins cannot handle. Likely
# an atypical encoding.
rm -f $(/shared/ruby_prod/ruby/1.9.3/bin/bundle show clamav)/spec/clamav-testfiles/*

if [ -d secret_ci ]; then
    echo "=-=-=-=-=-=-=-= delete secret_ci"
    rm -rf secret_ci
fi
echo "=-=-=-=-=-=-=-= git clone secret_ci"
git clone git@git.library.nd.edu:secret_ci

for f in database.yml doi.yml solr.yml fedora.yml redis.yml; do
    echo "=-=-=-=-=-=-=-= copy $f"
    cp secret_ci/curate_nd/$f config/$f
done
echo "=-=-=-=-=-=-=-= copy secret_token.rb"
cp secret_ci/curate_nd/secret_token.rb config/initializers/secret_token.rb

echo "=-=-=-=-=-=-=-= rake curatend:ci"
$WORKSPACE/vendor/bundle/bin/rake --trace curatend:ci
retval=$?

echo "=-=-=-=-=-=-=-= $0 finished $retval"
exit $retval
