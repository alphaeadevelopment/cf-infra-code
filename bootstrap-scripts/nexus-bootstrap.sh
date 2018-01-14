#!/bin/bash
yum update -y
yum install -y java-1.8.0-openjdk-headless.x86_64 nfs-utils jq

groupadd nexus
useradd -g nexus nexus
mkdir /opt/nexus


aws s3 cp s3://alphaea-uk-downloads/nexus-3.7.1-02-unix.tar.gz /opt/nexus/nexus-3.7.1-02-unix.tar.gz
cd /opt/nexus
tar xzf nexus-3.7.1-02-unix.tar.gz
rm -f nexus-3.7.1-02-unix.tar.gz
chown -R nexus:nexus /opt/nexus
echo "nexus - nofile 65536" >> /etc/security/limits.conf


aws s3 cp s3://alphaea-uk-scripts/nexus.init.d /etc/init.d/nexus
chmod 750 /etc/init.d/nexus


curl -w "\n" http://169.254.169.254/latest/meta-data/placement/availability-zone > /etc/az 2>/dev/null
cat /etc/az | (read h; echo ${h:0:-1}) > /etc/region
curl -w "\n" -H "Accept: application/json" http://169.254.169.254/latest/meta-data/instance-id > /etc/instance_id 2>/dev/null
aws ec2 describe-instances --region $(cat /etc/region) --filter Name=instance-id,Values=$(cat /etc/instance_id) > /etc/instance_details 2>/dev/null
jq '.Reservations[0].Instances[0].Tags[] | select(.Key=="EfsName")'.Value /etc/instance_details | awk -F "\"" '{print $2}' > /etc/efs_name



mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 $(cat /etc/efs_name).efs.eu-west-1.amazonaws.com:/ /opt/nexus/sonatype-work/

service nexus start
chkconfig nexus on



