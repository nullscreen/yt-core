require 'spec_helper'

describe 'Yt::Channel’s content details methods', :account do
  context 'given my own channel' do
    subject(:channel) { $own_channel }

    specify 'return all content details data with one HTTP call', requests: 2 do
      expect(channel.related_playlists).to be_a Hash
      expect(channel.related_playlists['likes']).to be_a String
      expect(channel.related_playlists['uploads']).to be_a String
      expect(channel.like_playlists).to all(be_a Yt::Playlist)
    end
  end
end
