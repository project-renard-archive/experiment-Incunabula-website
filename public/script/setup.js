require.config({
  baseUrl: '../vendor',
  paths: {
    "app": '../script'
  },
  shim: {
    backbone: {
      deps: ["underscore", "jquery"],
      exports: "Backbone"
    }
  },
  packages: [
    { name: 'jquery', main: 'jquery' },
    { name: 'underscore', main: 'underscore' },
    { name: 'backbone', main: 'backbone' },
    { name: 'd3', main: 'd3' },
    { name: 'cytoscape', main: 'cytoscape' },
    { name: 'cs', location: 'require-cs', main: 'cs' },
    { name: 'coffee-script', main: 'index' }
  ]
});

require( [ "cs!app/app" ], function(app) {
  new app();
});
