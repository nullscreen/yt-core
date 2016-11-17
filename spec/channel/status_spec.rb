require 'spec_helper'

describe 'Yt::Channel’s status methods', :server do
  subject(:channel) { Yt::Channel.new attrs }

  context 'given an existing channel ID' do
    let(:attrs) { {id: $existing_channel_id} }

    specify 'return all status data with one HTTP call' do
      expect(Net::HTTP).to receive(:start).once.and_call_original

      expect(channel.privacy_status).to eq 'public'
      expect(channel.is_linked).to be true
      expect(channel.long_upload_status).to eq 'longUploadsUnspecified'
    end
  end
end
