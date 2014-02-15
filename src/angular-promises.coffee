$q = null
$timeout = null

makeApplyCallback = (action, self) ->
  ->
    callbacks = self["__#{action}Callbacks__"].slice()
    self["__#{action}Callbacks__"] = []
    for callback in callbacks
      callback.apply(null, arguments)

class Promise

  # Promise is a wrapper for $q.defer().promise
  # that provides a similar promise interface
  # to jQuery.Deferred().promise,
  # with the added benefit of performing
  # a $scope.$apply on all promise callbacks,
  # to keep them in the angular event loop.
  #
  # Note: like jQuery but unlike $q, more than one
  #  callback can be registered on `done`, `fail` and `always`.
  #
  # Arguments:
  #   promise - $q.defer().promise to be wrapped (required)

  constructor : (promise) ->
    @__doneCallbacks__ = []
    @__failCallbacks__ = []
    @__alwaysCallbacks__ = []
    @__progressCallbacks__ = []
    promise.then(
      makeApplyCallback('done', this),
      makeApplyCallback('fail', this),
      makeApplyCallback('progress', this))
    promise.finally makeApplyCallback('always', this)
    this

  # Add handler to be called when Deferred object is resolved
  done : (callback) =>
    @__doneCallbacks__.push callback
    this

  # Add handler to be called when Deferred object is reject
  fail : (callback) =>
    @__failCallbacks__.push callback
    this

  # Add handler to be called when Deferred object is resolved or reject
  always : (callback) =>
    @__alwaysCallbacks__.push callback
    this

  # Add handler to be called when Deferred object sends a notification
  progress : (callback) =>
    @__progressCallbacks__.push callback
    this

class QNotDefinedError extends Error

  constructor : ->
    @name = 'QNotDefinedError'
    @message = '$q must injected. Did you instantiate Deferred with `new`?'

class TimeoutNotDefinedError extends Error

  constructor : ->
    @name = 'TimeoutNotDefinedError'
    @message = '$timeout must injected. Did you instantiate Deferred with `new`?'

performDeferredAction = (action, calledArguments) ->
  $timeout (=> @__deferred__[action].apply(this, calledArguments)), 0

class Deferred

  # Deferred is a wrapper for $q.defer()
  # that allows for chaining, ala jQuery.Deferred()
  # as well as a similar promise interface,
  # with the added benefit of performing
  # a $scope.$apply on all promise callbacks,
  # to keep them in the angular event loop.

  constructor : ->
    # $q and $timeout must be injected before creating an instance
    throw new QNotDefinedError unless $q
    throw new TimeoutNotDefinedError unless $timeout
    @__deferred__ = $q.defer()
    @__promise__ = new Promise @__deferred__.promise
    this

  # Resolve the Deferred object and call its handler
  resolve : =>
    performDeferredAction.call(this, 'resolve', arguments)
    this

  # Reject the Deferred object and call its handler
  reject : =>
    performDeferredAction.call(this, 'reject', arguments)
    this

  # Call the progress callback on a Deferred object
  notify : =>
    performDeferredAction.call(this, 'notify', arguments)
    this

  # Return the Deferred promise object
  promise : =>
    @__promise__

angular.module('angular-promises', [])
.factory 'Deferred', [
  '$q', '$timeout',
  (_$q_, _$timeout_) ->
    $q = _$q_
    $timeout = _$timeout_
    Deferred
]
