require 'json' # for JSON.parse

require 'yt/config'
require 'yt/no_items_error'
require 'yt/http_request'
require 'yt/relation'
require 'yt/resource'
require 'yt/response'

require 'yt/channel'
require 'yt/playlist'
require 'yt/playlist_item'
require 'yt/video'

# An object-oriented Ruby client for YouTube.
# Helps creating applications that need to interact with YouTube objects.
# Includes methods to access YouTube Data API V3 resources (channels, ...).
module Yt
  # A namespace for all the errors.
  module Errors
  end
end
