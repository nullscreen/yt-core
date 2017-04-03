require 'spec_helper'

describe 'Yt::Video.where', :server do
  subject(:videos) { Yt::Video.where id: video_ids }

  context 'given multiple video IDs (even more than 50)' do
    let(:video_ids) { %w(xwtdhWltSIg 5rOiW_xY-kc 0vqgdSsfqPs Hyk-Vdd_Qrk
      YYOKMUTTDdA _mSmOcmk7uQ _We6ubpUHZs ZITh-XIikgI BLhD-h1LRQs jWkMhCLkVOg
      k_JnCWT-_O8 AKKqLl_ZEEY ahJ6Kh8klM4 o2XubQsVwtY 5cnIQHJ169s mgiCechWNCo
      -UE7tXDKIus GvI_U8PJ-4Q PN1YpMtPIpE UIXs66BPooY kpwd1YLgDaM XTtixBih0PM
      -R2hvKDFLHE yZp8k4kxfHo ycvJHQUqU1M KIJGlTu5sEI 1LewYq40Svw uUcKeKt8C1k
      oC7er_6dpsI vu2jN3d2zzU SRR1a4LAdNA JlIj6BxUS6E eN1f4AFgiAc HiNV1rMNXE0
      9AuyPnxqhH4 Fuvi7AUfZPo zHlpWokiduk zmYTTQ-wark fKJoX5YXs98 aHntEjYG4w8
      4cdZQ41rGAg 60IBPy1wiBM OEwI3yKMxkI Kb3-9kgXU3U oE88MDZJ0K4 0XhYEqz2Hu8
      qGeq5v7L3WM uaqSSMs3mEM QqVI_CHlFAI 2JAjC7BSqAA 6mV1H8e2CgM RExRs_5jM9c) }

    it 'returns the list of *existing* videos matching the conditions' do
      videos = Yt::Video.where id: [$existing_video_id, $unknown_video_id]
      expect(videos).to be
      expect(videos.inspect).to be
      expect(videos).to all( be_a Yt::Video )
      expect(videos.map &:id).to eq [$existing_video_id]
    end

    it 'does not make any HTTP requests unless iterated', requests: 0 do
      videos
    end

    it 'makes as many HTTP requests as the number of videos divided by 50', requests: 2 do
      Yt::Video.where(id: video_ids).map &:id
    end

    it 'makes as many HTTP requests as the number of videos divided by 50 to calculate the size', requests: 2 do
      expect(Yt::Video.where(id: video_ids).size).to eq video_ids.size
    end

    it 'reuses the previous HTTP response if the request is the same', requests: 1 do
      Yt::Video.where(id: %w(zHlpWokiduk zmYTTQ-wark)).map &:id
      Yt::Video.where(id: %w(zHlpWokiduk zmYTTQ-wark)).map &:id
    end

    it 'makes a new HTTP request if the request has changed', requests: 2 do
      Yt::Video.where(id: %w(QqVI_CHlFAI 2JAjC7BSqAA)).map &:id
      Yt::Video.where(id: %w(1LewYq40Svw uUcKeKt8C1k)).map &:id
    end

    it 'allocates at most one Yt::Relation object, no matter the requests' do
      videos
      expect{videos}.not_to change{ObjectSpace.each_object(Yt::Relation).count}
    end

    it 'allocates at most 50 Yt::Video object, no matter the requests' do
      GC.start
      Yt::Video.where(id: %w(-R2hvKDFLHE yZp8k4kxfHo)).map &:id
      expect{Yt::Video.where(id: %w(-UE7tXDKIus GvI_U8PJ-4Q)).map &:id}.not_to change{GC.start; ObjectSpace.each_object(Yt::Video).count}
    end

    it 'accepts .select to fetch multiple parts with one HTTP calls', requests: 2 do
      list = videos.select :snippet, :status, :statistics, :content_details
      expect(list).to be
      expect(list.map &:title).to be
      expect(list.map &:privacy_status).to be
      expect(list.map &:view_count).to be
      expect(list.map &:duration).to be
    end
  end
end
