module Yt
  # Provides methods to interact with YouTube Analytics groups.
  # @see https://developers.google.com/youtube/analytics/v1/reference/groups
  class Group < Resource
    # @!attribute [r] title
    # @return [String] the group’s title.
    has_attribute :title, in: :snippet

    # @!attribute [r] published_at
    # @return [Time] the date and time that the group was created.
    has_attribute :published_at, in: :snippet, type: Time

    # @!attribute [r] item_count
    # @return [Integer] the number of items in the group.
    has_attribute :item_count, in: :content_details, type: Integer

    # @!attribute [r] item_type
    # @return [String] the type of items in the group.
    has_attribute :item_type, in: :content_details

    def initialize(data = {})
      super
      @selected_data_parts = %i(id snippet content_details)
    end

  private

    def part_params
      super.merge api: 'youtube/analytics/v1'
    end
  end
end
