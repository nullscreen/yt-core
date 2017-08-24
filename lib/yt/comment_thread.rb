module Yt
  # Provides methods to interact with YouTube comment threads.
  # @see https://developers.google.com/youtube/v3/docs/commentThreads
  class CommentThread < Resource
    # @!attribute [r] channel_id
    # @return [String] the ID of the channel that the comments refer to.
    # @return [nil] if the comment does not refer to a channel.
    has_attribute :channel_id, in: :snippet

    # @!attribute [r] video_id
    # @return [String] the ID of the video that the comments refer to.
    # @return [nil] if the comment refers to the channel itself.
    has_attribute :video_id, in: :snippet

    # @!attribute [r] top_level_comment
    # @return [Comment] the thread's top-level comment.
    has_attribute :top_level_comment, in: :snippet, type: Comment

    # @return [Yt::Relation<Yt::Comment>] the comments of a thread.
    def comments
      @comments ||= Relation.new(Comment, parent_id: id,
        initial_items: -> {[top_level_comment]}) do |options|
        get '/youtube/v3/comments', thread_comments_params(options)
      end
    end
  end
end
