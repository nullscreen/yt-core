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


A comprehensive guide to Yt
===========================

All the classes and methods available are detailed on the [Yt homepage](https://claudiob.github.io/yt/):

[![Yt homepage](https://cloud.githubusercontent.com/assets/10076/19788369/b61d7756-9c5c-11e6-8bd8-05f8d67aef4e.png)](https://claudiob.github.io/yt/)

Please proceed to [https://claudiob.github.io/yt/](https://claudiob.github.io/yt) for more details and examples.


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
