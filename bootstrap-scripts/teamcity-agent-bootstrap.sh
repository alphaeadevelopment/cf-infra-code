#!/bin/bash

yum update -y
yum install -y java-1.8.0-openjdk-headless.x86_64 nfs-utils git
update-alternatives --set java /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java

curl --silent --location https://rpm.nodesource.com/setup_8.x | bash -
yum -y install nodejs


groupadd teamcity
useradd -g teamcity -m -d /opt/teamcity teamcity


JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk.x86_64 bin/agent.sh start

export NEXUS_SERVER=http://nexus.alphaea.uk
export NPM_REPO_NAME=npm-releases

sudo -i -u teamcity npm config set @alphaeadev:registry ${NEXUS_SERVER}/repository/${NPM_REPO_NAME}/


sudo -u teamcity wget http://teamcitysetup.alphaea.uk/update/buildAgent.zip -O /opt/teamcity/buildAgent.zip
sudo -u teamcity unzip buildAgent.zip
rm -rf buildAgent.zip

sudo -u teamcity cp conf/buildAgent{.dist,}.properties
sed -i.bak -e 's/localhost:8111/teamcitysetup.alphaea.uk/' conf/buildAgent.properties

aws s3 cp s3://alphaea-uk-scripts/teamcity-agent.init.d /etc/init.d/teamcity
chmod 740 /etc/init.d/teamcity
service teamcity start