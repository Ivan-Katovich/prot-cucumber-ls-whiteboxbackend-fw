
export const driversProcesses = {
  chrome: /chromedriver_\d+\.\d+\.exe/,
  chromeHeadless: /chromedriver_\d+\.\d+\.exe/,
  firefox: /geckodriver-v\d*\.*\d+\.*\d+\.exe/,
  firefoxHeadless: /geckodriver-v\d*\.*\d+\.*\d+\.exe/,
  ie11: /IEDriverServer\d*\.*\d+\.*\d+\.exe/,
  edge: /MicrosoftWebDriver.exe/, //not sure about name
  safari: 'safaridriver'
};

export const browsersProcesses = {
  chrome: 'chrome.exe',
  chromeHeadless: 'chrome.exe',
  firefox: 'firefox.exe',
  firefoxHeadless: 'firefox.exe',
  ie11: 'iexplore.exe',
  edge: 'edge.exe', //not sure about name
  safari: 'Safari'
};
