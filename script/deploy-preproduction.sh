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

source $WORKSPACE/script/common-deploy.sh

do_deploy pre_production

echo "This should not be reached"
exit 1
