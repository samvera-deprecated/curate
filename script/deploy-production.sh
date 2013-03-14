#!/usr/bin/env bash

# Setup and run capistrano to deploy the production application and workers
#
# This runs on the same host as jenkins
#
# called from Jenkins command
#       Build -> Execute Shell Command ==
#       test -x $WORKSPACE/script/deploy-production.sh && $WORKSPACE/script/deploy-production.sh
echo "=-=-=-=-=-=-=-= start $0"

source $WORKSPACE/script/common-deploy.sh

do_deploy production
