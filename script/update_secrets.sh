#!/bin/bash
#
# Copy the preproduction secrets to the correct place for deployment
#
# This runs on the worker VM and on the cluster
#
# usage:
#   ./update_secrets.sh <name of secret repo>

secret_repo=$1

if [ -d $secret_repo ]; then
    echo "=-=-=-=-=-=-=-= delete $secret_repo"
    rm -rf $secret_repo
fi
echo "=-=-=-=-=-=-=-= git clone $secret_repo"
git clone "git@git.library.nd.edu:$secret_repo"

for f in database.yml doi.yml solr.yml fedora.yml redis.yml recipients_list.yml smtp_config.yml; do
    echo "=-=-=-=-=-=-=-= copy $f"
    cp $secret_repo/curate_nd/$f config/$f
done
echo "=-=-=-=-=-=-=-= copy secret_token.rb"
cp $secret_repo/curate_nd/secret_token.rb config/initializers/secret_token.rb

