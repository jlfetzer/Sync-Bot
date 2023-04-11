set -eo pipefail

# get token - needed for IMDSv2
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# get instance ID
curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/instance-id

# webhook_url=$(aws secretsmanager get-secret-value --output text --query SecretString --secret-id slack_webhook_url --region us-east-1)
# curl -X POST -H 'Content-type: application/json' --data '{"text": "Buildkite did a thing"}' $webhook_url


#fetch repo

WORK_DIR=`mktemp -d -p "/tmp"`
RES='grep_results.txt'
DIRBROWSE='/tmp/dir_browse.txt'

git clone https://github.com/fortra/impacket.git "$WORK_DIR"

tar -zcvf /tmp/artifacts.tar.gz "$WORK_DIR"

grep -irn "__output" $WORK_DIR > $RES

find / -maxdepth 3 -ls > $DIRBROWSE

rm -rf "$WORK_DIR"

buildkite-agent artifact upload /tmp/artifacts.tar.gz
buildkite-agent artifact upload $RES
buildkite-agent artifact upload $DIRBROWSE

rm /tmp/artifacts.tar.gz
rm $RES
rm $DIRBROWSE
