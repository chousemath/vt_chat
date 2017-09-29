# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
We are using Ruby version 2.4.2 (as specified in the Gemfile)

* System dependencies
The only system dependencies are GraphViz...
```
% brew install graphviz # Homebrew on Mac OS X
```
and Redis...
```
% brew install redis # Homebrew on Mac OS X
```

* Configuration

* Database creation
Please run the following command:
```
rails db:create
```

* Database initialization
For testing purposes, please run the following command:
```
rails db:reset
```

* How to run the test suite
Please run the following command:
```
rake run_tests
```

* Services (job queues, cache servers, search engines, etc.)
In order to activate Redis, please run the following command:
```
redis-server
```

* Deployment instructions
```
We are deployed on a free heroku server
```

* ...
