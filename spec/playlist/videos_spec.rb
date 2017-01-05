require 'spec_helper'

describe 'Yt::Playlist#videos', :server do
  subject(:playlist) { Yt::Playlist.new attrs }

  context 'given an existing playlist ID' do
    let(:attrs) { {id: $existing_playlist_id} }

    it 'returns the list of *public* videos of the playlist' do
      expect(playlist.videos).to all( be_a Yt::Video )
    end

    it 'does not make any HTTP requests unless iterated' do
      expect(Net::HTTP).not_to receive(:start)
      playlist.videos
    end

    it 'makes as many HTTP requests as the number of items divided by 50' do
      expect(Net::HTTP).to receive(:start).twice.and_call_original
      playlist.videos.map &:id
    end

    it 'reuses the previous HTTP response if the request is the same' do
      expect(Net::HTTP).to receive(:start).twice.and_call_original
      playlist.videos.map &:id
      playlist.videos.map &:id
    end

    it 'makes a new HTTP request if the request has changed' do
      expect(Net::HTTP).to receive(:start).exactly(6).times.and_call_original
      playlist.videos.map &:id
      playlist.videos.select(:id, :snippet).map &:title
    end

    it 'allocates at most one Yt::Relation object, no matter the requests' do
      expect{playlist.videos}.to change{ObjectSpace.each_object(Yt::Relation).count}
      expect{playlist.videos}.not_to change{ObjectSpace.each_object(Yt::Relation).count}
    end

    it 'allocates at most 50 Yt::Playlist object, no matter the requests' do
      expect{playlist.videos.map &:id}.to change{GC.start; ObjectSpace.each_object(Yt::Playlist).count}
      expect{playlist.videos.map &:id}.not_to change{GC.start; ObjectSpace.each_object(Yt::Playlist).count}
      expect{playlist.videos.select(:status).map &:privacy_status}.not_to change{GC.start; ObjectSpace.each_object(Yt::Playlist).count}
      expect{playlist.videos.limit(4).map &:id}.not_to change{GC.start; ObjectSpace.each_object(Yt::Playlist).count}
    end

    it 'accepts .select to fetch multiple parts with two HTTP calls' do
      expect(Net::HTTP).to receive(:start).exactly(4).times.and_call_original

      videos = playlist.videos.select :snippet, :status, :statistics, :content_details
      expect(videos.map &:title).to be_present
      expect(videos.map &:privacy_status).to be_present
      expect(videos.map &:view_count).to be_present
      expect(videos.map &:duration).to be_present
    end

    it 'accepts .limit to only fetch some videos' do
      expect(Net::HTTP).to receive(:start).twice.and_call_original
      expect(playlist.videos.select(:snippet).limit(2).count).to be 2
    end
  end
end
