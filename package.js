Package.describe({
  // Short two-sentence summary
  summary: 'Meteor Payeer integration',
  version: '0.1.0',
  name: 'boomfly:meteor-payeer',
  git: 'https://github.com/boomfly/meteor-payeer'
});


Package.onUse((api) => {
  api.versionsFrom('1.6');

  api.use('underscore', 'server');
  api.use('ecmascript', ['server', 'client']);
  api.use('coffeescript', ['server', 'client']);
  // api.imply('coffeescript', 'server');

  api.mainModule('src/payeer.coffee', 'server');
  api.mainModule('src/payment-form.coffee', 'client');
});
// This defines the tests for the package:
Package.onTest((api) => {
  // Sets up a dependency on this package.
  api.use('underscore', 'server');
  api.use('ecmascript', 'server');
  api.use('coffeescript@2.0.2_1', 'server');
  api.use('boomfly:meteor-payeer');
  // Specify the source code for the package tests.
  api.addFiles('test/test.coffee', 'server');
});
// This lets you use npm packages in your package:
Npm.depends({
  'sprintf-js': '1.1.1',
  'xml-js': '1.5.2',
  'js2xml': '1.0.8',
  'react': '16.0.0'
});
