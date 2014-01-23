Couchbase-Lite-Demo-CRM
=======================

# Logs

Use these Commandline Arguments to see verbose logs of syncronization process:

`
-LogSync YES
-LogSyncVerbose YES
-LogRemoteRequest YES
-Log YES
`

# Tips and Tricks 

### See changes
`
curl http://USERNAME:PASWORD@syncadm.couchbasecloud.com:8083/DB_NAME/_changes
`

### Check Users
`
curl http://USERNAME:PASWORD@syncadm.couchbasecloud.com:8083/DB_NAME/_user/
`

### Check concreat user

`
curl http://USERNAME:PASWORD@syncadm.couchbasecloud.com:8083/DB_NAME/_user/USER_NAME
{"name":"USERNAME","all_channels":["all_docs"],"email":"email@gmail.com","roles":["admin"]}
`

### To PUT something

`
curl -v -XPUT http://USERNAME:PASWORD@syncadm.couchbasecloud.com:8083/DB_NAME/_user/USER_NAME -d '{"all_channels":["all_docs"],"roles":["admin"]}'
`