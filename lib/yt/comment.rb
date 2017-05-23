module Yt
  # Provides methods to interact with YouTube comments.
  # @see https://developers.google.com/youtube/v3/docs/comments
  class Comment < Resource
    # @!attribute [r] author_channel_id
    # @return [String] the comment’s text.
    has_attribute :text_display, in: :snippet

    # @!attribute [r] author_display_name
    # @return [String] the display name of the user who posted the comment.
    has_attribute :author_display_name, in: :snippet

    # @!attribute [r] author_profile_image_url
    # @return [String] the URL of the avatar of the user who posted the comment.
    has_attribute :author_profile_image_url, in: :snippet

    # @!attribute [r] author_channel_url
    # @return [String] the URL of the comment author’s YouTube channel.
    has_attribute :author_channel_url, in: :snippet

    # @!attribute [r] author_channel_id
    # @return [String] the ID of the comment author’s YouTube channel.
    has_attribute :author_channel_id, in: :snippet do |author_channel_id|
      author_channel_id['value']
    end
  end
end
