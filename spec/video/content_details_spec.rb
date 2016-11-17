require 'spec_helper'

describe 'Yt::Video’s content details methods', :server do
  subject(:video) { Yt::Video.new attrs }

  context 'given an existing video ID' do
    let(:attrs) { {id: $existing_video_id} }

    specify 'return all content details data with one HTTP call' do
      expect(Net::HTTP).to receive(:start).once.and_call_original

      expect(video.duration).to eq 'PT2S'
      expect(video.seconds).to be 2
      expect(video.hh_mm_ss).to eq '00:00:02'
      expect(video.dimension).to eq '2d'
      expect(video.definition).to eq 'sd'
      expect(video.caption).to be false
      expect(video.licensed_content).to be false
      expect(video.projection).to eq 'rectangular'
    end
  end
end
