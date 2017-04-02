require 'spec_helper'

describe 'Yt::Playlist’s snippet methods', :server do
  subject(:playlist) { Yt::Playlist.new attrs }

  context 'given an existing playlist ID' do
    let(:attrs) { {id: $existing_playlist_id} }

    specify 'return all snippet data with one HTTP call', requests: 1 do
      expect(playlist.title).to eq 'First public playlist'
      expect(playlist.description).to eq 'A YouTube playlist to test the yt gem.'
      expect(playlist.published_at).to eq Time.parse('2016-11-18 00:40:02 UTC')
      expect(playlist.thumbnail_url).to be_a String
      expect(playlist.channel_id).to eq 'UCwCnUcLcb9-eSrHa_RQGkQQ'
      expect(playlist.channel_title).to eq 'Yt Test'
    end
  end

  context 'given an unknown playlist ID' do
    let(:attrs) { {id: $unknown_playlist_id} }

    specify 'raise Yt::NoItemsError' do
      expect{playlist.title}.to raise_error Yt::NoItemsError
    end
  end
end

