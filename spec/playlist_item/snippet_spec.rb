require 'spec_helper'

describe 'Yt::PlaylistItem’s snippet methods', :server do
  subject(:item) { Yt::PlaylistItem.new attrs }

  context 'given an existing item ID' do
    let(:attrs) { {id: $existing_item_id} }

    specify 'return all snippet data with one HTTP call', requests: 1 do
      expect(item.title).to eq 'First public video'
      expect(item.description).to eq 'A YouTube video to test the yt gem.'
      expect(item.published_at).to eq Time.parse('2016-11-18 23:40:55 UTC')
      expect(item.thumbnail_url).to be_a String
      expect(item.channel_id).to eq 'UCwCnUcLcb9-eSrHa_RQGkQQ'
      expect(item.channel_title).to eq 'Yt Test'
      expect(item.playlist_id).to eq 'PL-LeTutc9GRKD3yBDhnRF_yE8UTaQI5Jf'
      expect(item.position).to eq 0
      expect(item.video_id).to eq 'gknzFj_0vvY'
    end
  end

  context 'given an unknown item ID' do
    let(:attrs) { {id: $unknown_item_id} }

    specify 'raise Yt::Errors::NoItems' do
      expect{item.title}.to raise_error Yt::Errors::NoItems
    end
  end
end

