Yt - a Ruby client for the YouTube API
======================================

Yt helps you write apps that need to interact with YouTube.

The **source code** is available on [GitHub](https://github.com/fullscreen/yt-core) and the **documentation** on [RubyDoc](http://www.rubydoc.info/gems/yt-core/frames).

[![Build Status](http://img.shields.io/travis/Fullscreen/yt-core/master.svg)](https://travis-ci.org/Fullscreen/yt-core)
[![Coverage Status](http://img.shields.io/coveralls/Fullscreen/yt-core/master.svg)](https://coveralls.io/r/Fullscreen/yt-core)
[![Dependency Status](http://img.shields.io/gemnasium/Fullscreen/yt-core.svg)](https://gemnasium.com/Fullscreen/yt-core)
[![Code Climate](http://img.shields.io/codeclimate/github/Fullscreen/yt-core.svg)](https://codeclimate.com/github/Fullscreen/yt-core)
[![Online docs](http://img.shields.io/badge/docs-✓-green.svg)](http://www.rubydoc.info/gems/yt/frames)
[![Gem Version](http://img.shields.io/gem/v/yt.svg)](http://rubygems.org/gems/yt-core)

After [registering your app](https://fullscreen.github.io/yt-core/), you can run commands like:

```ruby
channel = Yt::Channel.new id: 'UCwCnUcLcb9-eSrHa_RQGkQQ'
channel.title #=> "Yt Test"
```

The **full documentation** is available at [rubydoc.info](http://www.rubydoc.info/gems/yt/frames).


A comprehensive guide to Yt
===========================

All the classes and methods available are detailed on the [Yt homepage](https://fullscreen.github.io/yt-core/):

[![Yt homepage](https://cloud.githubusercontent.com/assets/10076/19788369/b61d7756-9c5c-11e6-8bd8-05f8d67aef4e.png)](https://fullscreen.github.io/yt-core/)

Please proceed to [https://fullscreen.github.io/yt-core](https://fullscreen.github.io/yt-core/) for more details and examples.


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

This will fail unless you have set up a test YouTube application with access to
the YouTube Data API v3 and an environment variable:

- `YT_SERVER_API_KEY`: API Key of a Google app with access to the YouTube Data API v3 and the YouTube Analytics API


How to release new versions
===========================

If you are a manager of this project, remember to upgrade the [Yt gem](http://rubygems.org/gems/yt)
whenever a new feature is added or a bug gets fixed.

Make sure all the tests are passing on [Travis CI](https://travis-ci.org/Fullscreen/yt-core),
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
- to list undocumented methods: `bundle exec yard stats --list-undoc`
- to launch the guides locally: `bundle exec jekyll s -s docs`
