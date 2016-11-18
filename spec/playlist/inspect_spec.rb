require 'spec_helper'

describe 'Yt::Playlist#inspect' do
  subject(:playlist) { Yt::Playlist.new attrs }

  context 'given any playlist ID' do
    let(:attrs) { {id: 'PL-234567890abcdefgh'} }

    specify 'prints out a compact version of the object' do
      expect(playlist.inspect).to eq '#<Yt::Playlist @id=PL-234567890abcdefgh>'
    end
  end
end
