# express-redis-lock

[![Build Status](https://travis-ci.org/jakubknejzlik/express-redis-lock.svg?branch=master)](https://travis-ci.org/jakubknejzlik/express-redis-lock)

Route based locking methods for preventing race conditions using [redis-lock](https://www.npmjs.com/package/redis-lock)


# Example

```
// initialize express/redis
var express = require('express');
var redis = require('redis');
var expressRedisLock = require('express-redis-lock');

var app = express();
var client = redis.createClient();

app.use(expressRedisLock(client));


// use lock/unlock methods
app.get('/locked-request',(req,res,next)->
  res.lock('test-key',next) // only one request at time can pass
)
app.get('/locked-request',(req,res,next)->
  res.unlock('test-key') // manually release lock when done (lock is released automatically when response is sent)
)
```
