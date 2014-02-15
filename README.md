# angular-promises

angular-promises is a wrapper for Angular's $q.defer that allows for chaining, ala jQuery.Deferred(), as well as a similar promise interface, with the added benefit of performing a $scope.$apply on all promise callbacks, to keep them in the angular event loop.

## setup
`npm install`

## test
`npm test` - Requires [PhantomJS](http://phantomjs.org)

## use
Install via bower:
`bower install angular-promises`

Or include dist/angular-promises.js in your project.

## documentation
### Deferred
Methods (all but `promise` return deferred instance):

`resolve` - Resolve the Deferred object and call its handler

`reject` - Reject the Deferred object and call its handler

`notify` - Call the progress callback on a Deferred object

`promise` - Return the Deferred promise object

### Promise

Methods (all return promise instance):

`done` - Add handler to be called when Deferred object is resolved

`fail` - Add handler to be called when Deferred object is reject

`always` - Add handler to be called when Deferred object is resolved or reject

`progress` - Add handler to be called when Deferred object sends a notification


Note: like jQuery but unlike $q, more than one callback can be registered on `done`, `fail` and `always`.

## example

```javascript
// Deferred object
var deferred = new Deferred();

// Promise
var someAsyncFunction = function() {
  var deferred = new Deferred();
  setTimeout(function(){
    deferred.resolve();
  }, 1000);
  return deferred.promise();
};
var promise = someAsyncFunction();
promise.done(onDone).fail(onFail).always(thingIAlwaysDo);
```