require 'spec_helper'

describe 'Yt::Playlist’s status methods', :server do
  subject(:playlist) { Yt::Playlist.new attrs }

  context 'given an existing playlist ID' do
    let(:attrs) { {id: $existing_playlist_id} }

    specify 'return all status data with one HTTP call' do
      expect(Net::HTTP).to receive(:start).once.and_call_original

      expect(playlist.privacy_status).to eq 'public'
    end
  end
end
