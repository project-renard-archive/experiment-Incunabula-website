require.config({
  baseUrl: '../vendor',
  paths: {
    "app": '../script'
  },
  shim: {
  },
  packages: [
    { name: 'd3', main: 'd3' },
    { name: 'cs', location: 'require-cs', main: 'cs' },
    { name: 'coffee-script', main: 'index' }
  ]
});

require( [ "cs!app/app" ], function(app) {
  new app();
});
