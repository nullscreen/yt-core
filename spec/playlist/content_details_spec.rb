require 'spec_helper'

describe 'Yt::Playlist’s content details methods', :server do
  subject(:playlist) { Yt::Playlist.new attrs }

  context 'given an existing playlist ID' do
    let(:attrs) { {id: $existing_playlist_id} }

    specify 'return all content details data with one HTTP call', requests: 1 do
      expect(playlist.item_count).to be 52
    end
  end
end
