#!/bin/sh
PUPPET='/usr/local/bin/puppet'

echo ""
echo `$PUPPET config print localcacert`
echo ""

echo ""
echo "Update/Sync Classes"
echo ""
curl -X POST -H 'Content-Type: application/json' \
--cacert `$PUPPET config print localcacert` \
--cert   `$PUPPET config print hostcert` \
--key    `$PUPPET config print hostprivkey` \
--insecure \
https://localhost:4433/classifier-api/v1/update-classes

echo ""
echo '#### Create SND Apache classifier ####'
echo ""
curl -X POST -H 'Content-Type: application/json' -d '{ "environment_trumps": true, "parent": "00000000-0000-4000-8000-000000000000", "name": "SND WWT-Apache", "rule": [ "and", [ "~", [ "fact", "fqdn" ], "apache-1" ] ], "variables": { }, "environment": "sandbox", "classes": { "wwt_apache": { } } }' \
--cacert `$PUPPET config print localcacert` \
--cert   `$PUPPET config print hostcert` \
--key    `$PUPPET config print hostprivkey` \
--insecure \
https://localhost:4433/classifier-api/v1/groups

echo ""
echo '#### Create Jenkins Master classifier ####'
echo ""
curl -X POST -H 'Content-Type: application/json' -d '{ "environment_trumps": true, "parent": "00000000-0000-4000-8000-000000000000", "name": "SND CI-Master", "rule": [ "and", [ "~", [ "fact", "fqdn" ], "jenkins-master" ] ], "variables": { }, "environment": "sandbox", "classes": { "cifilesystem": { }, "deployerapi": { }, "jenkins": { "libdir": "/opt/ci/jenkins" }, "jenkins::master": { } } }' \
--cacert `$PUPPET config print localcacert` \
--cert   `$PUPPET config print hostcert` \
--key    `$PUPPET config print hostprivkey` \
--insecure \
https://localhost:4433/classifier-api/v1/groups

echo ""
echo '#### Create Jenkins Slave classifier ####'
echo ""
curl -X POST -H 'Content-Type: application/json' -d '{ "environment_trumps": true, "parent": "00000000-0000-4000-8000-000000000000", "name": "SND CI-Slave", "rule": [ "and", [ "~", [ "fact", "fqdn" ], "jenkins-slave" ] ], "variables": { }, "environment": "sandbox", "classes": { "cifilesystem": { }, "deployerapi": { }, "jenkins": { "libdir": "/opt/ci/jenkins" }, "jenkins::slave": { "masterurl": "http://jenkins-master.wwt.local:8080" } } }' \
--cacert `$PUPPET config print localcacert` \
--cert   `$PUPPET config print hostcert` \
--key    `$PUPPET config print hostprivkey` \
--insecure \
https://localhost:4433/classifier-api/v1/groups

echo ""
echo ""
echo "Update/Sync Classes"
curl -X POST -H 'Content-Type: application/json' \
--cacert `$PUPPET config print localcacert` \
--cert   `$PUPPET config print hostcert` \
--key    `$PUPPET config print hostprivkey` \
--insecure \
https://localhost:4433/classifier-api/v1/update-classes

echo ""
echo "Show all classifcation groups"
echo ""
curl https://puppetmaster:4433/classifier-api/v1/groups --cert `$PUPPET config print hostcert` --key `$PUPPET config print hostprivkey` --cacert `$PUPPET config print localcacert` -H "Content-Type: application/json"
echo ""
