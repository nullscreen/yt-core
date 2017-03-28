require 'spec_helper'

describe 'Yt::Video#channel', :server do
  subject(:video) { Yt::Video.new attrs }

  context 'given an existing video ID' do
    let(:attrs) { {id: $existing_video_id} }

    it 'returns the channel the video belongs to' do
      expect(video.channel).to be_a Yt::Channel
    end

    it 'accepts .select to fetch multiple parts with two HTTP calls', requests: 2 do
      channel = video.select(:snippet).channel.select(:snippet)
      expect(channel.id).to eq video.channel_id
      expect(channel.title).to eq video.channel_title
    end
  end
end
