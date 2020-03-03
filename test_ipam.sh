#!/usr/bin/env bash
#
# Run CNI plugin tests.
# 
# This needs sudo, as we'll be creating net interfaces.
#
set -e

# switch into the repo root directory
cd "$(dirname $0)"

# Build all plugins before testing
source ./build_ipam.sh

echo "Running tests"

function testrun {
    sudo -E bash -c "umask 0; cd $GOPATH/src; PATH=${GOROOT}/bin:$(pwd)/bin:${PATH} go test $@"
}

PKG=${PKG:-$(cd ${GOPATH}/src/${REPO_PATH}; go list ./... | xargs echo)}
# coverage profile only works per-package

PLUGINS="cipo"
for t in $PLUGINS; do
    testrun github.com/containernetworking/plugins/plugins/ipam/${t}
done

echo 'done.'