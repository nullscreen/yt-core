require 'spec_helper'

describe 'Yt::Channel’s statistics methods', :server do
  subject(:channel) { Yt::Channel.new attrs }

  context 'given an existing channel ID' do
    let(:attrs) { {id: $existing_channel_id} }

    specify 'return all statistics data with one HTTP call' do
      expect(Net::HTTP).to receive(:start).once.and_call_original

      expect(channel.view_count).to be > 0
      expect(channel.comment_count).to be_an Integer # TODO: create a comment
      expect(channel.subscriber_count).to be > 0
      expect(channel.hidden_subscriber_count).to be false
      expect(channel.video_count).to be > 0
    end
  end
end
