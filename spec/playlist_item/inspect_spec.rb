require 'spec_helper'

describe 'Yt::PlaylistItem#inspect' do
  subject(:item) { Yt::PlaylistItem.new attrs }

  context 'given any item ID' do
    let(:attrs) { {id: 'UEwtTGVUdXRjOUdSS0QzeUJEaG5SRl95RThVVGFRSTVKZi41NkI0NEY2RDEwNTU3Q0M2'} }

    specify 'prints out a compact version of the object' do
      expect(item.inspect).to eq '#<Yt::PlaylistItem @id=UEwtTGVUdXRjOUdSS0QzeUJEaG5SRl95RThVVGFRSTVKZi41NkI0NEY2RDEwNTU3Q0M2>'
    end
  end
end
