# Changelog

All notable changes to this project will be documented in this file.

For more information about changelogs, check
[Keep a Changelog](http://keepachangelog.com) and
[Vandamme](http://tech-angels.github.io/vandamme).

## 0.1.7 - 2017-08-27

* [FEATURE] Add `Channel#groups` and `Yt::Group`
* [ENHANCEMENT] Call `Yt#Auth.access_token_was_refreshed` after refreshing a token.

## 0.1.6 - 2017-08-26

* [ENHANCEMENT] Compatibility with yt-auth 0.3.0.

## 0.1.5 - 2017-08-24

* [FEATURE] Add `Yt::PlaylistItem.insert` and `Yt::PlaylistItem#delete`
* [FEATURE] Add `Channel#related_playlists` and `Channel#like_playlists`
* [FEATURE] Add Channel.mine

## 0.1.4 - 2017-06-02

* [FEATURE] Add CommentThread#comments

## 0.1.3 - 2017-05-23

* [FEATURE] Add Comment and CommentThread
* [FEATURE] Add Channel#featured_channels_title and Channel#featured_channels_urls

## 0.1.2 - 2017-04-06

* [BUGFIX] Fix cases like `channel.select(:snippet).view_count` where attribute does not belong to any selected part.

## 0.1.1 - 2017-04-04

* [ENHANCEMENT] Add :defaults to `has_attribute`
* [BUGFIX] Video#tags returns `[]` and not `nil` when a video has no tags

## 0.1.0 - 2017-04-03

* [FEATURE] Extracted first classes from Yt
