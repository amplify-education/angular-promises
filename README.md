Deferred is a wrapper for $q.defer()
that allows for chaining, ala jQuery.Deferred()
as well as a similar promise interface,
with the added benefit of performing
a $scope.$apply on all promise callbacks,
to keep them in the angular event loop.