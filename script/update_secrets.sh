#!/bin/bash

#
# Copy the preproduction secrets to the correct place for deployment
#
# This runs on the worker VM

if [ -d secret_pprd ]; then
    echo "=-=-=-=-=-=-=-= delete secret_pprd"
    rm -rf secret_pprd
fi
echo "=-=-=-=-=-=-=-= git clone secret_pprd"
git clone git@git.library.nd.edu:secret_pprd

for f in database.yml solr.yml fedora.yml redis.yml; do
    echo "=-=-=-=-=-=-=-= copy $f"
    cp secret_pprd/curate_nd/$f config/$f
done

