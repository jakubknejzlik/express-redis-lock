Lock = require('redis-lock')

module.exports = (client)->
  l = Lock(client)
  return (req,res,next)->

    if not res._redisLocks

      res._redisLocks = res._redisLocks or {}

      res.lock = (lockName,next)->
        l(lockName,(done)->
          res._redisLocks[lockName] = done
          next()
        )
        res.once('finish',()->
          res.unlock(lockName)
        )

      res.unlock = (lockName)->
        unlock = res._redisLocks[lockName]
        if unlock
          delete res._redisLocks[lockName]
          unlock()

#    if lockName
#      res.lock(lockName)

    next()