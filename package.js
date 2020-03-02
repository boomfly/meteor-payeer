Package.describe({
  // Short two-sentence summary
  summary: 'Meteor Payeer integration',
  version: '0.1.1',
  name: 'boomfly:meteor-payeer',
  git: 'https://github.com/boomfly/meteor-payeer'
});


Package.onUse((api) => {
  api.versionsFrom('1.6');

  api.use('underscore', 'server');
  api.use('ecmascript', ['server', 'client']);
  api.use('coffeescript@2.0.2_1', ['server', 'client']);
  // api.imply('coffeescript', 'server');

  api.addAssets('src/php.php', 'server');

  api.mainModule('src/payeer.coffee', 'server');
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
  'js2xml': '1.0.9'
});
