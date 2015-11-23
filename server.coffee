koa = require 'koa'
cors = require('koa-cors')
router = require('koa-router')()
bodyJSON = require('koa-parse-json')
app = koa()
server = require('http').Server(app.callback())
io = require('socket.io')(server)

config = require './config/app.json'

uFCoder = new ( require './uFCoder/ufcoder' )(io)

router.post '/write',
  bodyJSON()
  (next) ->
    data = JSON.stringify this.request.body
    @body = null
    @body = ( yield uFCoder.linearWrite(data) )
    yield uFCoder.readerUISignal(0,3)
    yield next

router.get '/test',
  (next) ->
    @body = 'test'
    yield next

app.use cors()

app.use (next) ->
  try
    yield next
  catch error
    @status = error.status || 500;
    @body =
      statusCode: @status
      message: error.message

app.use router.routes()

server.listen config.port, config.host
