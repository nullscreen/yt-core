require 'spec_helper'

describe 'Yt::PlaylistItem’s status methods', :server do
  subject(:item) { Yt::PlaylistItem.new attrs }

  context 'given an existing item ID' do
    let(:attrs) { {id: $existing_item_id} }

    specify 'return all status data with one HTTP call' do
      expect(Net::HTTP).to receive(:start).exactly(1).times.and_call_original

      expect(item.privacy_status).to eq 'public'
    end
  end
end
