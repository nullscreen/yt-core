require 'spec_helper'

describe 'Yt::PlaylistItem’s status methods', :server do
  subject(:item) { Yt::PlaylistItem.new attrs }

  context 'given an existing item ID' do
    let(:attrs) { {id: $existing_item_id} }

    specify 'return all status data with one HTTP call', requests: 1 do
      expect(item.privacy_status).to eq 'public'
    end
  end

  context 'given an item ID for a removed video' do
    let(:attrs) { {id: $removed_item_id} }

    specify 'raise Yt::NoItemsError' do
      expect{item.privacy_status}.to raise_error Yt::NoItemsError
    end
  end
end
