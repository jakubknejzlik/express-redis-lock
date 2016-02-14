assert = require('assert')
express = require('express')
redis = require('redis')
supertest = require('supertest')
async = require('async')

expressRedisLock = require('../index')

app = express()
client = redis.createClient()

staticValue = 0

app.use(expressRedisLock(client))

app.get('/no-lock',(req,res,next)->
  next()
)
app.get('/lock',(req,res,next)->
  res.lock('test',next)
)
app.all('*',(req,res,next)->
  staticValue++
  setTimeout(()->
    res.send({value:staticValue})
  ,100)
)

test = supertest(app)

describe('lock testing',()->
  it('should return invalid results for no-lock',(done)->
    staticValue = 0
    async.times(10,(n,cb)->
      test.get('/no-lock')
      .expect(200)
      .expect({value:10})
      .end(cb)
    ,done)
  )
  it('should return valid results for lock',(done)->
    staticValue = 0
    async.times(10,(n,cb)->
      test.get('/lock')
      .expect(200)
      .expect({value:n+1})
      .end(cb)
    ,done)
  )
)