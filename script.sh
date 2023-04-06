set -eo pipefail

# get token - needed for IMDSv2
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# get instance ID
curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/instance-id

# webhook_url=$(aws secretsmanager get-secret-value --output text --query SecretString --secret-id slack_webhook_url --region us-east-1)
# curl -X POST -H 'Content-type: application/json' --data '{"text": "Buildkite did a thing"}' $webhook_url


#fetch repo

WORK_DIR=`mktemp -d -p "/tmp"`

git clone https://github.com/fortra/impacket.git "$WORK_DIR"

tar -zcvf /tmp/artifacts.tar.gz "$WORK_DIR"

rm -rf "$WORK_DIR"

buildkite-agent artifact upload /tmp/artifacts.tar.gz

rm /tmp/artifacts.tar.gz
