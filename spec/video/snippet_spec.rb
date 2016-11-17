require 'spec_helper'

describe 'Yt::Video’s snippet methods', :server do
  subject(:video) { Yt::Video.new attrs }

  context 'given an existing video ID' do
    let(:attrs) { {id: $existing_video_id} }

    specify 'return all snippet data with one HTTP call' do
      expect(Net::HTTP).to receive(:start).once.and_call_original

      expect(video.published_at).to eq Time.parse('2016-10-20 02:19:05 UTC')
      expect(video.channel_id).to eq 'UCwCnUcLcb9-eSrHa_RQGkQQ'
      expect(video.title).to eq 'First public video'
      expect(video.description).to eq 'A YouTube video to test the yt gem.'
      expect(video.thumbnail_url).to be_a String
      expect(video.channel_title).to eq 'Yt Test'
      expect(video.tags).to eq ['yt', 'test', 'tag']
      expect(video.category_id).to eq 22
      expect(video.live_broadcast_content).to eq 'none'
    end
  end

  context 'given an unknown video ID' do
    let(:attrs) { {id: $unknown_video_id} }

    specify 'raise Yt::Errors::NoItems' do
      expect{video.title}.to raise_error Yt::Errors::NoItems
    end
  end
end
