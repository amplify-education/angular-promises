# angular-promises

angular-promises is a wrapper for Angular's $q.defer that allows for chaining, ala jQuery.Deferred(), as well as a similar promise interface, with the added benefit of performing a $scope.$apply on all promise callbacks, to keep them in the angular event loop.

## setup
`npm install`

## test
`npm test` - Requires [PhantomJS](http://phantomjs.org)