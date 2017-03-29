require 'json' # for JSON.parse
require 'yt/config'

require 'yt/auth_request'
require 'yt/auth_error'


require 'yt/resource'

require 'yt/channel'
require 'yt/playlist'
require 'yt/playlist_item'
require 'yt/relation'
require 'yt/video'

require 'yt/errors/no_items'

# An object-oriented Ruby client for YouTube.
# Helps creating applications that need to interact with YouTube objects.
# Includes methods to access YouTube Data API V3 resources (channels, ...).
module Yt
  # A namespace for all the errors.
  module Errors
  end
end
