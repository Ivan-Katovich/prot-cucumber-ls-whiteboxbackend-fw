# advantageplus test framework
Protractor cucumber typescript framework

## Setup framework

Preconditions: Ruby, Python, Node.js

Open a command window and run:

    npm install 

Then you should update and run local webdriver-manager using tasks:

    npm run wd-update
    npm run wd-start
    
Then you should run web application locally or run it on any existing environments (ppe, dev, stg, qat, live):

    npm run start (run web app locally)
    
The main task for tests running is:

    npm run ui-cucumber
    
The main parameters for test running is:

    --env=ppe (it runs tests on PPE environment, possible values: ppe, dev, stg, qat, live)
    --appVersion=1.20 (it passes on application version into tests (used in '@version-check' test))
    --browser=chrome (it runs tests on different browsers, possible values for now: chrome(default), firefox)
    --size=1280,1050 (it manages browser's window size, default value = 1680,1050)
    --tags=@wip,@smoke (it runs only tests tagged as @wip and @smoke in the example, but tags can be different)
    --selenium=virtual (it runs tests through different selenium servers)
    
The main flags is:

    --wd (runs webdriver-manager in background process so you don't need to run it before tests)
    --app (runs web app in background process so you don't need to run it before tests for local testing)
    --rerun (run rerun tests failed in previous test run)
    --newacc (create new account for test execution)
    --dryrun (invoke formatters without executing steps)
    --mail (send email to involved people)


