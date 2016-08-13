# Tweet Battle

Demo: [https://matt-barackman-tweet-stream.herokuapp.com/](https://matt-barackman-tweet-stream.herokuapp.com/)

Tweet Battle is a sample project showing off my general web development proficiencies.

Functionally, it allows you to visualize the recent Twitter activity around certain topics in real-time. For funsies I've chosen the user names for Hillary Clinton and Donald Trump.

At any given time you can see the following stats for each topic over the past hour:
- the total number of tweets it was mentioned in.
- the top `users`, `hashtags`, and `links` mentioned in those tweets.

Note:
As all number reflect the total counts for the last hour in real-time, the counts may go up or down as new mentions come in or as old ones fall outside the one hour window.

## Design Goals

- Real-time data processing
- Real-time asynchronous client updates (with animations!)
- Architecture to accomodate additional topics and additional activity windows (e.g. last 10 minutes, last minute, etc.)
  - I was originally using redis to store occurrences and expiring the occurrence keys after an hour long TTL, but I decided on adopting the above design goal, and therefore moved to postgres where I could query time ranges.


## Architecture

1. A long-running [Tweet::Stream](https://github.com/tweetstream/tweetstream) rake task that queues jobs to redis for each tweet matching one of the topic keywords: "HillaryClinton" and "realDonaldTrump"
2. A long-running [Sidekiq](https://github.com/mperham/sidekiq) worker dispatcher to persist all of the components of those tweets: `hashtags`, `usernames`, and `urls`.
3. A long-running [Puma](https://github.com/puma/puma) webserver running the [Ruby on Rails](http://rubyonrails.org/) / [React](https://facebook.github.io/react/) application to view the topic counts.
4. A cron job for cleaning up occurrences (of hashtags, urls, urls, and tweets) that are over an hour old. This runs every 10 minutes and is scheduled through [Heroku Scheduler](https://elements.heroku.com/addons/scheduler).


## Dependencies:

- Redis
- PostgreSQL
- Ruby 2.3.0 / Bundler / Foreman
- Twitter API Keys

## Set-up:

1. clone app locally: `git clone git@github.com:mattbarackman/twitter_project.git`
2. copy environment variable file: `cp .env.sample .env`
3. add twitter api keys to environment variable file
4. start local redis server: `redis-server`
5. set up local databases: `rake db:create; rake db:migrate; rake db:test:prepare`
6. install gems: `bundle install`


## Starting Application
1. use foreman to start all processes: `foreman start`


## Running Tests:

1. run ruby tests using  `rspec spec`


## To Do:

1. Write javascript tests
