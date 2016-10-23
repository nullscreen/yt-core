require 'active_support' # does not load anything by default
require 'active_support/core_ext/object/to_query' # for Hash.to_param
require 'active_support/core_ext/hash/transform_values' # for Hash#transform_values
require 'active_support/core_ext/object/blank' # for Object#presence
require 'active_support/hash_with_indifferent_access' # for HashWithIndifferentAccess#new
require 'active_support/core_ext/hash/indifferent_access' # for a bug in Rails

require 'json' # for JSON.parse

require 'yt/account'
require 'yt/channel'
require 'yt/configuration'
require 'yt/content_owner'
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
