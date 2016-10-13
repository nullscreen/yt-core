require 'active_support' # does not load anything by default
require 'active_support/core_ext/object/to_query' # for Hash.to_param
require 'json' # for JSON.parse

require 'yt/models/channel'
require 'yt/errors/no_items'

# An object-oriented Ruby client for YouTube.
# Helps creating applications that need to interact with YouTube objects.
# Includes methods to access YouTube Data API V3 resources (channels, ...).
module Yt
  # A namespace for all the models.
  module Models
  end

  # A namespace for all the errors.
  module Errors
  end
end
