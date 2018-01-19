yum update -y
yum install -y java-1.8.0-openjdk-headless.x86_64 nfs-utils
update-alternatives --set java /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java


groupadd teamcity
useradd -g teamcity -d /opt/teamcity -m teamcity

mkdir /opt/teamcity
wget https://download.jetbrains.com/teamcity/TeamCity-2017.2.1.tar.gz -O /opt/teamcity/teamcity.tar.gz


chown -R teamcity:teamcity /opt/teamcity

sudo -u teamcity c
