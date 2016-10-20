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

Yt::ContentOwner
----------------

Check [claudiob.github.io/yt](http://claudiob.github.io/yt/content_owners.html) for the list of methods available for `Yt::ContentOwner`.


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
Yt.configure do |config|
  config.api_key = '123456789012345678901234567890'
end
```

Remember: this kind of app is not allowed to perform any destructive operation,
so you won’t be able to like a video, subscribe to a channel or delete a
playlist from a specific account. You will only be able to retrieve read-only
data.

Web apps that require user interactions
---------------------------------------

If you are building a web app that acts on behalf of YouTube accounts, you need
the owner of each account to authorize your app.

If you already have the account’s **refresh token**, go to the
[Google Developers Console](https://console.developers.google.com),
find the web application that was used to obtain the refresh token, copy the
Client ID and Client secret and add them to your app with the following snippet
of code (replacing with your own keys):

```ruby
Yt.configure do |config|
  config.client_id = '1234567890.apps.googleusercontent.com'
  config.client_secret = '1234567890'
end
```
Then you can act as a YouTube account by passing the refresh token to the
account initializer:

```ruby
account = Yt::Account.new refresh_token: '1/1234567890'
account.videos #=> (lists the videos of an account)
```

Configuring with environment variables
--------------------------------------

As an alternative to the approach above, you can configure your app with
variables. Setting the following environment variables:

```bash
export YT_CLIENT_ID="1234567890.apps.googleusercontent.com"
export YT_CLIENT_SECRET="1234567890"
export YT_API_KEY="123456789012345678901234567890"
```

is equivalent to configuring your app with the initializer:

```ruby
Yt.configure do |config|
  config.client_id = '1234567890.apps.googleusercontent.com'
  config.client_secret = '1234567890'
  config.api_key = '123456789012345678901234567890'
end
```

so use the approach that you prefer.
If a variable is set in both places, then `Yt.configure` takes precedence.


How to test
===========

To run live-tests against the YouTube API, type:

```bash
rspec
```

This will fail unless you have set up a test YouTube application and some
tests YouTube accounts to hit the API. If you cannot run tests locally, you
can open PR against the repo and Travis CI will run the tests for you.

These are the environment variables required to run the tests in `spec/requests/as_server_app`:

- `YT_SERVER_API_KEY`: API Key of a Google app with access to the YouTube Data API v3 and the YouTube Analytics API

These are the environment variables required to run the tests in `spec/requests/as_account`:

- `YT_ACCOUNT_CLIENT_ID`: OAuth 2.0 client ID of a Google app with access to the YouTube Data API v3 and the YouTube Analytics API
- `YT_ACCOUNT_CLIENT_SECRET`: OAuth 2.0 client secret for the previous ID
- `YT_ACCOUNT_REFRESH_TOKEN`: refresh token for a YouTube account who granted permission to that app with scopes: yt-analytics.readonly, youtube.
- `YT_ACCOUNT_CHANNEL_ID`: ID of the YouTube channel owned by the previous account

These are the environment variables required to run the tests in `spec/requests/as_content_owner`:

- `YT_PARTNER_CLIENT_ID`: OAuth 2.0 client ID of a Google app with access to the YouTube Data API v3, the YouTube Analytics API, and the YouTube Content ID API
- `YT_PARTNER_CLIENT_SECRET`: OAuth 2.0 client secret for the previous ID
- `YT_PARTNER_REFRESH_TOKEN`: refresh token for a YouTube partner who granted permission to that app with scopes: yt-analytics.readonly, yt-analytics-monetary.readonly, youtubepartner and with access to the following CMS features: 'Channels', 'Analytics & Reports'.
- `YT_PARTNER_ID`: ID of the YouTube partner (CMS) that granted the previous refresh token
- `YT_PARTNER_CHANNEL_ID`: ID of a YouTube channel managed by the previous partner

Note that [The YouTube Content ID API](https://developers.google.com/apps-script/advanced/youtube-content-id) is intended for use by YouTube content partners and is not accessible to all developers or to all YouTube users.

No environment variables are required to run the tests in `spec/models`.


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
