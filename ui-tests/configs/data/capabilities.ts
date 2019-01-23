process.env.npm_config_size = process.env.npm_config_size ? process.env.npm_config_size : '1680,1050';

export let capabilities = {
  chrome: {
    browserName: 'chrome',
    'goog:chromeOptions': {
      args: [
        'disable-infobars',
        `--window-size=${process.env.npm_config_size}`,
        '--no-sandbox'
      ]
    }
  },

  chromeHeadless: {
    browserName: 'chrome',
    'goog:chromeOptions': {
      args: [
        'disable-infobars',
        '--disable-gpu',
        `--headless`,
        `--window-size=${process.env.npm_config_size}`,
        '--no-sandbox'
      ]
    }
  },

  firefox: {
    browserName : 'firefox',
    marionette: true,
    javascriptEnabled: true
  },

  firefoxHeadless: {
    browserName : 'firefox',
    marionette: true,
    javascriptEnabled: true,
    'moz:firefoxOptions': {
      args: ['--headless']
    }
  },

  ie11: {
    browserName: 'internet explorer',
    version: '11',
    requireWindowFocus: false,
    ensureCleanSession: true,
    'ie.ensureCleanSession': true,
    javascriptEnabled: true,
    allowBlockedContent: true,
    ignoreProtectedModeSettings: true,
    browserAttachTimeout: 30000,
    browserTimeout: 60000,
    platform: 'ANY',
  },

  edge: {
    browserName: 'MicrosoftEdge',
    javascriptEnabled: true,
    platform: 'Windows 10'
  },

  safari: {
    browserName: 'safari',
    javascriptEnabled: true,
    ensureCleanSession: true,
    browserTimeout: 60000
  }
};
