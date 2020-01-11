#!/usr/bin/env bash

set -e
set -o pipefail
set -v

initialGitHash=$(git rev-list --max-parents=0 HEAD)
node ./studio-build.js $initialGitHash &

curl -s -X POST https://api.stackbit.com/project/5e1a00a98f8f7a0019224237/webhook/build/pull > /dev/null
npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5e1a00a98f8f7a0019224237
curl -s -X POST https://api.stackbit.com/project/5e1a00a98f8f7a0019224237/webhook/build/ssgbuild > /dev/null
gatsby build
wait

curl -s -X POST https://api.stackbit.com/project/5e1a00a98f8f7a0019224237/webhook/build/publish > /dev/null
echo "Stackbit-build.sh finished build"
