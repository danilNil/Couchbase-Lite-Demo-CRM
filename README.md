Couchbase-Lite-Demo-CRM
=======================

# Running

1. download Couchbase Sync Gateway: http://www.couchbase.com/nosql-databases/downloads
2. move sync_gateway bin file to a directory that is included in your $PATH environment variable. For example: usr/local/bin  

3. Prepare Sync Gateway Config:

	```
	{
	   "log": ["CRUD", "CRUD+", "HTTP", "HTTP+", "Access", "Cache", "Changes", "Changes+"],
	   "interface":":4984",
	   "adminInterface":":14985",
	   "facebook":{
	      "register":true
	   },
	   "databases":{
	      "gw":{
	         "server":"walrus:/Users/danil/Documents/temp",
	         "bucket":"default",
	         "sync": ` function(doc, oldDoc) {
						  channel("all_docs");
						  if (doc.type === "salesperson") {
						    var userID = doc.user_id;
						    //if user logged as admin we add him access to all_docs channel and role
						    if (doc.isAdmin) {
						      access(userID, "all_docs")
						      role(userID, "role:admin")
						    }
						    if (oldDoc) {
						      //salespeople can only be approved by admin. when we approve sales person we grant him access to all_docs channel
						      if(doc.approved && !oldDoc.approved){
						        access(userID, "all_docs")
						        requireRole("admin")
						      }
						      else{
						        //salespeople can only be edited by themselves
						        requireUser(userID)  
						      }
						    }
						    else{
						      //salespeople can only be created by themselves
						      requireUser(userID)
						    }
						  }
						} `
	      }
	   }
	}
	```

4. Start sync_gateway with current config file: `sync_gateway syncgateway_walrus_config.json`
5. Change `kSyncUrl` in `Constants.h` to `http://YOUR_IP:4984/gw`  
 	- `gw` - data base name specified in `syncgateway_walrus_config.json` 
	- `YOUR_IP` - you can find your ip by using `ifconfig` command
6. Run application on your device and simulator
7. Turn on logging as admin to add modification in data base
8. See how data is synchronized between simulator and device
9. You can find how to setup your env with real server here: http://www.atkit.com/dev/couchbase-sync-gateway-setup-in-5-minutes-4-couchbase-lite/


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