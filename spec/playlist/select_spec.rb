require 'spec_helper'

describe 'Yt::Playlist#select', :server do
  subject(:subject) { Yt::Playlist.new attrs }

  context 'given an existing playlist ID' do
    let(:attrs) { {id: $existing_playlist_id} }

    specify 'lets multiple data parts be fetched with one HTTP call', requests: 1 do
      playlist = subject.select :snippet, :status, :content_details

      expect(playlist.id).to be
      expect(playlist.title).to be
      expect(playlist.privacy_status).to be
      expect(playlist.item_count).to be
    end
  end
end
