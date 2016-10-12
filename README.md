Yt - a Ruby client for the YouTube API
======================================================

Yt helps you write apps that need to interact with YouTube.

The **source code** is available on [GitHub](https://github.com/claudiob/yt) and the **documentation** on [RubyDoc](http://www.rubydoc.info/gems/yt/frames).

[![Build Status](http://img.shields.io/travis/claudiob/yt/master.svg)](https://travis-ci.org/claudiob/yt)
[![Coverage Status](http://img.shields.io/coveralls/claudiob/yt/master.svg)](https://coveralls.io/r/claudiob/yt)
[![Dependency Status](http://img.shields.io/gemnasium/claudiob/yt.svg)](https://gemnasium.com/claudiob/yt)
[![Code Climate](http://img.shields.io/codeclimate/github/claudiob/yt.svg)](https://codeclimate.com/github/claudiob/yt)
[![Online docs](http://img.shields.io/badge/docs-✓-green.svg)](http://www.rubydoc.info/gems/yt/frames)
[![Gem Version](http://img.shields.io/gem/v/yt.svg)](http://rubygems.org/gems/yt)

After [registering your app](#configuring-your-app), you can run commands like:

```ruby
channel = Yt::Channel.new id: 'UCwCnUcLcb9-eSrHa_RQGkQQ'
channel.title #=> "Yt Test"
```

The **full documentation** is available at [rubydoc.info](http://www.rubydoc.info/gems/yt/frames).

How to install
==============

To install on your system, run

    gem install yt

To use inside a bundled Ruby project, add this line to the Gemfile:

    gem 'yt', '~> 0.0.0'

Since the gem follows [Semantic Versioning](http://semver.org),
indicating the full version in your Gemfile (~> *major*.*minor*.*patch*)
guarantees that your project won’t occur in any error when you `bundle update`
and a new version of Yt is released.

Available resources
===================

Yt::Channel
-----------

Check [claudiob.github.io/yt](http://claudiob.github.io/yt/channels.html) for the list of methods available for `Yt::Channel`.


Configuring your app
====================

In order to use Yt you must register your app in the [Google Developers Console](https://console.developers.google.com).

If you don’t have a registered app, browse to the console and select "Create Project":
![01-create-project](https://cloud.githubusercontent.com/assets/7408595/3373043/4224c894-fbb0-11e3-9f8a-4d96bddce136.png)

When your project is ready, select APIs & Auth in the menu and individually enable Google+, YouTube Analytics and YouTube Data API:
![02-select-api](https://cloud.githubusercontent.com/assets/4453997/8442701/5d0f77f4-1f35-11e5-93d8-07d4459186b5.png)
![02a-enable google api](https://cloud.githubusercontent.com/assets/4453997/8442306/0f714cb8-1f33-11e5-99b3-f17a4b1230fe.png)
![02b-enable youtube api](https://cloud.githubusercontent.com/assets/4453997/8442304/0f6fd0e0-1f33-11e5-981a-acf90ccd7409.png)
![02c-enable youtube analytics api](https://cloud.githubusercontent.com/assets/4453997/8442305/0f71240e-1f33-11e5-9b60-4ecea02da9be.png)

The next step is to create an API key. Depending on the nature of your app, you should pick one of the following strategies.

Apps that do not require user interactions
------------------------------------------

If you are building a read-only app that fetches public data from YouTube, then
all you need is a **Public API access**.

Click on "Create new Key" in the Public API section and select "Server Key":
![03-create-key](https://cloud.githubusercontent.com/assets/7408595/3373045/42258fcc-fbb0-11e3-821c-699c8a3ce7bc.png)
![04-create-server-key](https://cloud.githubusercontent.com/assets/7408595/3373044/42251db2-fbb0-11e3-93f9-8f06f8390b4e.png)

Once the key for server application is created, copy the API key and add it
to your code with the following snippet of code (replacing with your own key):

```ruby
ENV['YT_API_KEY'] = '123456789012345678901234567890'
```

Remember: this kind of app is not allowed to perform any destructive operation,
so you won’t be able to like a video, subscribe to a channel or delete a
playlist from a specific account. You will only be able to retrieve read-only
data.

Configuring with environment variables
--------------------------------------

As an alternative to the approach above, you can configure your app with
variables. Setting the following environment variables:

```bash
export YT_API_KEY="123456789012345678901234567890"
```

is equivalent to configuring your app with the initializer:

```ruby
ENV['YT_API_KEY'] = '123456789012345678901234567890'
```

How to test
===========

To run live-tests against the YouTube API, type:

```bash
rspec
```

This will fail unless you have set up a test YouTube application and some
tests YouTube accounts to hit the API. If you cannot run tests locally, you
can open PR against the repo and Travis CI will run the tests for you.


How to release new versions
===========================

If you are a manager of this project, remember to upgrade the [Yt gem](http://rubygems.org/gems/yt)
whenever a new feature is added or a bug gets fixed.

Make sure all the tests are passing on [Travis CI](https://travis-ci.org/claudiob/yt),
document the changes in HISTORY.md and README.md, bump the version, then run

    rake release

Remember that the yt gem follows [Semantic Versioning](http://semver.org).
Any new release that is fully backward-compatible should bump the *patch* version (0.0.x).
Any new version that breaks compatibility should bump the *minor* version (0.x.0)

How to contribute
=================

Contribute to the code by forking the project, adding the missing code,
writing the appropriate tests and submitting a pull request.

In order for a PR to be approved, all the tests need to pass and all the public
methods need to be documented and listed in the guides. Remember:

- to run all tests locally: `bundle exec rspec`
- to generate the docs locally: `bundle exec yard`
- to launch the guides locally: `bundle exec jekyll s -s docs`
