ffi = require 'ffi'
ref = require 'ref'
ArrayType = require('ref-array')
co = require 'co'
jsonminify = require("jsonminify")
Iconv  = require('iconv').Iconv

libname = 'libuFCoder-x86'
if process.arch == 'x64'
  libname += '_64'

CharArray = ArrayType(ref.types.char)

uFCoderLib = new ffi.Library "#{__dirname}/lib/#{libname}", {
  "ReaderOpen": [ "int", [] ]
  "ReaderClose": [ "int", [] ]
  "GetReaderType": [ "int", [ ref.refType('uint32') ] ]
  "GetCardId": [ "int", [ ref.refType('uint8'), ref.refType('uint32') ] ]
  "ReaderUISignal": [ "int", [ 'int', 'int' ] ]
  ###
  uint8_t *aucData,
  uint16_t usLinearAddress,
  uint16_t usDataLength,
  uint16_t *lpusBytesReturned,
  uint8_t ucKeyMode,
  uint8_t ucReaderKeyIndex
  ###
  "LinearRead": [ "int", [ CharArray, 'int', 'int', ref.refType('uint16'), 'int', 'int'] ]
  ###
  uint8_t *aucData,
  uint16_t usLinearAddress,
  uint16_t usDataLength,
  uint16_t *lpusBytesWritten,
  uint8_t ucKeyMode,
  uint8_t ucReaderKeyIndex
  ###
  "LinearWrite": [ "int", [ CharArray, 'int', 'int', ref.refType('uint16'), 'int', 'int'] ]
}

class UFCRequestQueue
  constructor: () ->
    @queue = []
    @inProgress = false

  add: (uFCoderLibFunction, params) ->
    new Promise (resolve, reject) =>
      request =
        fce: uFCoderLibFunction
        params: params
        resolve: resolve
        reject: reject
      @queue.push request
      @process()

  process: () ->
    if !@inProgress and @queue.length > 0
      @inProgress = true
      request = @queue.shift()
      request.params.push (error, result) =>
        @inProgress = false
        @process()
        if error then return request.reject error
        request.resolve result
      request.fce.async.apply(@, request.params)

class UFCoder
  constructor: (io) ->
    @io = io
    @uFCRequestQueue = new UFCRequestQueue()
    @cardSnaped = false
    co @detectCard()

  detectCard: () ->
    console.log 'here'
    try
      card = yield @getCardId()
      if !@cardSnaped
        data =
          card:
            type: card.cardType
            serial: card.cardSerial
        data.data =
          JSONraw: yield @linearRead()
        try
          data.data.JSON = JSON.parse data.data.JSONraw
        catch error
          console.log error
        @io.emit 'card', data
        yield @uFCRequestQueue.add uFCoderLib.ReaderUISignal, [0, 1]
        console.log data
      @cardSnaped = true
    catch error
      console.log error
      @cardSnaped = false
    finally
      yield (callback) ->
        setTimeout callback, 500
      co @detectCard()

  checkStatus: (status) ->
    if status == 164
      yield ( @uFCRequestQueue.add uFCoderLib.ReaderClose, [] )
    if status == 161
      yield ( @uFCRequestQueue.add uFCoderLib.ReaderOpen, [] )
    if status != 0
      throw new Error "uFCoder status #{status}"
    yield return

  readerOpen: () ->
    status = yield ( @uFCRequestQueue.add uFCoderLib.ReaderOpen, [] )
    yield @checkStatus status
    status

  getReaderType: () ->
    readerType = ref.alloc('uint32')
    status = yield ( @uFCRequestQueue.add uFCoderLib.GetReaderType, [readerType] )
    yield @checkStatus status
    readerType.deref()

  getCardId: () ->
    cardType = ref.alloc('uint8')
    cardSerial = ref.alloc('uint32')
    status = yield ( @uFCRequestQueue.add uFCoderLib.GetCardId, [cardType, cardSerial] )
    yield @checkStatus status

    return {
      cardType: cardType.deref()
      cardSerial: cardSerial.deref()
    }

  readerUISignal: (light, sound) ->
    status = yield ( @uFCRequestQueue.add uFCoderLib.ReaderUISignal, [light, sound] )
    yield @checkStatus status
    return status

  linearRead: () ->
    aucData = new CharArray(752)
    lpusBytesReturned = ref.alloc('uint16')
    status = yield ( @uFCRequestQueue.add uFCoderLib.LinearRead, [aucData, 0, aucData.length, lpusBytesReturned, 96 , 0] )
    data = ''
    for i in [0..lpusBytesReturned.deref()-1]
      if aucData[i] == 0 then break
      # When non ASCII character appear
      try
        data += String.fromCharCode( aucData[i] )
      catch error
        console.log error
        break
    #console.log aucData.deref()
    #console.log lpusBytesReturned.deref()
    yield @checkStatus status
    return data

  linearWrite: (data) ->
    #data = '{"title": "Example Schema","type": "object ça va が"}'
    data = jsonminify data
    iconv = new Iconv('UTF-8', 'ASCII//TRANSLIT//IGNORE')
    data = iconv.convert data
    aucData = new CharArray(752)
    for key in [0..aucData.length-1]
      aucData[key] = ""

    for char, key in data
      aucData[key] = char

    lpusBytesReturned = ref.alloc('uint16')
    status = yield ( @uFCRequestQueue.add uFCoderLib.LinearWrite, [aucData, 0, aucData.length, lpusBytesReturned, 96 , 0] )
    #console.log lpusBytesReturned.deref()
    yield @checkStatus status
    return {
      data: data
      written: lpusBytesReturned.deref()
    }

module.exports = UFCoder

###
readerType = ref.alloc('uint32')
console.log uFCoder.ReaderOpen()
console.log uFCoder.GetReaderType(readerType)
console.log readerType.deref()
###
#console.log uFCoder.GetCardId()
