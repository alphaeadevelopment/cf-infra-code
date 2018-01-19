#!/bin/bash

yum update -y
curl --silent --location https://rpm.nodesource.com/setup_8.x | bash -
yum -y install nodejs git jq
npm install -g nodemon

groupadd node
useradd node -g node

curl -w "\n" http://169.254.169.254/latest/meta-data/placement/availability-zone > /etc/az 2>/dev/null
cat /etc/az | (read h; echo ${h:0:-1}) > /etc/region
curl -w "\n" -H "Accept: application/json" http://169.254.169.254/latest/meta-data/instance-id > /etc/instance_id 2>/dev/null
aws ec2 describe-instances --region $(cat /etc/region) --filter Name=instance-id,Values=$(cat /etc/instance_id) > /etc/instance_details 2>/dev/null
jq '.Reservations[0].Instances[0].Tags[] | select(.Key=="Port")'.Value /etc/instance_details | awk -F "\"" '{print $2}' > /etc/node_port
jq '.Reservations[0].Instances[0].Tags[] | select(.Key=="NodeModule")'.Value /etc/instance_details | awk -F "\"" '{print $2}' > /etc/node_module

NODE_MODULE=$(cat /etc/node_module)
NEXUS_SERVER=http://nexus.alphaea.uk
NPM_REPO_NAME=npm-releases

cd /home/node
npm config set @alphaeadev:registry ${NEXUS_SERVER}/repository/${NPM_REPO_NAME}/
git clone https://github.com/alphaeadevelopment/${NODE_MODULE}.git
cd ${NODE_MODULE}
npm install && NODE_ENV=production npm run build

chown -R node:node .

aws s3 cp s3://alphaea-uk-scripts/node.init.d /etc/init.d/node
chmod 750 /etc/init.d/node

service node start
chkconfig node on
