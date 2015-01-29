PUPPET='/usr/local/bin/puppet'

echo `$PUPPET config print localcacert`

echo "Update Classes"
echo ""
curl -X POST -H 'Content-Type: application/json' \
--cacert `$PUPPET config print localcacert` \
--cert   `$PUPPET config print hostcert` \
--key    `$PUPPET config print hostprivkey` \
--insecure \
https://localhost:4433/classifier-api/v1/update-classes

echo ""
echo "Get Groups"
curl https://puppetmaster:4433/classifier-api/v1/groups --cert `$PUPPET config print hostcert` --key `$PUPPET config print hostprivkey` --cacert `$PUPPET config print localcacert` -H "Content-Type: application/json"
echo ""

echo '#### Create New Classifier ####'
curl -X POST -H 'Content-Type: application/json' \
-d \
  '{  
      "environment_trumps":true,
      "parent":"00000000-0000-4000-8000-000000000000",
      "name":"SND CI",
      "rule":[  
         "and",
         [  
            "~",
            [  
               "fact",
               "fqdn"
            ],
            "^.*gent.*\\.wwt\\.local$"
         ]
      ],
      "variables":{  

      },
      "environment":"sandbox",
      "classes":{  
         "java":{  
            "package":"java-1.8.0-openjdk.x86_64",
            "distribution":"jdk"
         }
      }
   }' \
  "variables": {"package": "java-1.8.0-openjdk.x86_64"}
 }'\
--cacert `$PUPPET config print localcacert` \
--cert   `$PUPPET config print hostcert` \
--key    `$PUPPET config print hostprivkey` \
--insecure \
https://localhost:4433/classifier-api/v1/groups
