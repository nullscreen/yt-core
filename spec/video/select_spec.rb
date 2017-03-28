require 'spec_helper'

describe 'Yt::Video#select', :server do
  subject(:subject) { Yt::Video.new attrs }

  context 'given an existing video ID' do
    let(:attrs) { {id: $existing_video_id} }

    specify 'lets multiple data parts be fetched with one HTTP call', requests: 1 do
      video = subject.select :snippet, :status, :statistics, :content_details

      expect(video.id).to be
      expect(video.title).to be
      expect(video.privacy_status).to be
      expect(video.view_count).to be
      expect(video.duration).to be
    end
  end
end
