require 'spec_helper'

describe 'Yt::Video’s status methods', :server do
  subject(:video) { Yt::Video.new attrs }

  context 'given an existing video ID' do
    let(:attrs) { {id: $existing_video_id} }

    specify 'return all status data with one HTTP call', requests: 1 do
      expect(video.upload_status).to eq 'processed'
      expect(video.privacy_status).to eq 'public'
      expect(video.license).to eq 'youtube'
      expect(video.embeddable).to be true
      expect(video.public_stats_viewable).to be true
    end
  end
end
