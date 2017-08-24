require 'spec_helper'

describe 'Yt::PlaylistItem.insert and .delete', :account do
  subject(:item) { Yt::PlaylistItem.insert attrs }
  let(:attrs) { {playlist_id: playlist_id, video_id: video_id} }

  context 'given my own playlist and an existing video' do
    # ADD TO README: requires your own account to have at least one playlist
    let(:playlist_id) { $own_channel.playlists.first.id }
    let(:video_id) { $existing_video_id }

    specify 'add and remove the video from the playlist', requests: 3 do
      expect(item).to be_a Yt::PlaylistItem
      expect(item.title).to be_a String
      expect(item.description).to be_a String
      expect(item.published_at).to be_a Time
      expect(item.thumbnail_url).to be_a String
      expect(item.channel_id).to be_a String
      expect(item.channel_title).to be_a String
      expect(item.playlist_id).to eq playlist_id
      expect(item.video_id).to eq video_id

      expect(item.delete).to be true
    end
  end
end
