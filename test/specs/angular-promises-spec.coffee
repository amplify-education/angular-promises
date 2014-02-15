describe 'Deferred', ->

  Deferred = $q = $timeout = null

  beforeEach angular.mock.module 'angular-promises'

  beforeEach angular.mock.inject (_Deferred_, _$q_, _$timeout_) ->
    Deferred = _Deferred_
    $q = _$q_
    $timeout = _$timeout_

  describe 'constructor', ->

    it 'creates a $q.defer object', ->
      spyOn($q, 'defer').and.callThrough()
      deferred = new Deferred()
      expect($q.defer).toHaveBeenCalled()
      expect(deferred.__deferred__).toBeTruthy()

    it 'creates a promise', ->
      deferred = new Deferred()
      expect(deferred.__promise__).toBeTruthy()

  describe 'resolve', ->

    deferred = __deferred__ = null

    beforeEach ->
      deferred = new Deferred()
      __deferred__ = deferred.__deferred__
      spyOn(__deferred__, 'resolve')

    it 'calls resolve on the deferred object', ->
      onResolve = ->
      promise = deferred.resolve(onResolve)
      $timeout.flush()
      expect(__deferred__.resolve).toHaveBeenCalledWith(onResolve)

    it 'returns the deferred object', ->
      promise = deferred.resolve()
      expect(promise instanceof Deferred).toBeTruthy()

  describe 'reject', ->

    deferred = __deferred__ = null

    beforeEach ->
      deferred = new Deferred()
      __deferred__ = deferred.__deferred__
      spyOn(__deferred__, 'reject')

    it 'calls reject on the deferred object', ->
      onReject = ->
      deferred.reject(onReject)
      $timeout.flush()
      expect(__deferred__.reject).toHaveBeenCalledWith(onReject)

    it 'returns the deferred object', ->
      promise = deferred.reject()
      expect(promise instanceof Deferred).toBeTruthy()

  describe 'notify', ->

    deferred = __deferred__ = null

    beforeEach ->
      deferred = new Deferred()
      __deferred__ = deferred.__deferred__
      spyOn(__deferred__, 'notify')

    it 'calls notify on the deferred object', ->
      onNotify = ->
      promise = deferred.notify(onNotify)
      $timeout.flush()
      expect(__deferred__.notify).toHaveBeenCalledWith(onNotify)

    it 'returns the deferred object', ->
      promise = deferred.notify()
      expect(promise instanceof Deferred).toBeTruthy()

  describe 'promise', ->

    deferred = __promise__ = null

    beforeEach ->
      deferred = new Deferred()
      __promise__ = deferred.__promise__

    it 'returns the attached promise', ->
      expect(deferred.promise()).toEqual __promise__

  describe 'Promise', ->

    it 'attaches callbacks to all states', ->
      qDefer = promise : {then : jasmine.createSpy(), finally : jasmine.createSpy()}
      spyOn($q, 'defer').and.returnValue qDefer
      new Deferred()
      expect(qDefer.promise.then).toHaveBeenCalledWith(
        jasmine.any(Function), jasmine.any(Function), jasmine.any(Function))
      expect(qDefer.promise.finally).toHaveBeenCalledWith jasmine.any(Function)
