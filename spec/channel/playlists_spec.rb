require 'spec_helper'

describe 'Yt::Channel#playlists', :server do
  subject(:channel) { Yt::Channel.new attrs }

  context 'given an existing channel ID' do
    let(:attrs) { {id: $existing_channel_id} }

    it 'returns the list of *public* playlists of the channel' do
      expect(channel.playlists).to all( be_a Yt::Playlist )
    end

    it 'does not make any HTTP requests unless iterated' do
      expect(Net::HTTP).to receive(:start).exactly(0).times.and_call_original
      channel.playlists
    end

    it 'makes as many HTTP requests as the number of playlists divided by 50' do
      expect(Net::HTTP).to receive(:start).exactly(1).times.and_call_original
      channel.playlists.map &:id
    end

    it 'reuses the previous HTTP response if the request is the same' do
      expect(Net::HTTP).to receive(:start).exactly(1).times.and_call_original
      channel.playlists.map &:id
      channel.playlists.map &:id
    end

    it 'makes a new HTTP request if the request has changed' do
      expect(Net::HTTP).to receive(:start).exactly(2).times.and_call_original
      channel.playlists.map &:id
      channel.playlists.select(:id, :snippet).map &:title
    end

    it 'allocates at most one Yt::Relation object, no matter the requests' do
      expect{channel.playlists}.to change{ObjectSpace.each_object(Yt::Relation).count}
      expect{channel.playlists}.not_to change{ObjectSpace.each_object(Yt::Relation).count}
    end

    it 'allocates at most 50 Yt::Playlist object, no matter the requests' do
      expect{channel.playlists.map &:id}.to change{GC.start; ObjectSpace.each_object(Yt::Playlist).count}
      expect{channel.playlists.map &:id}.not_to change{GC.start; ObjectSpace.each_object(Yt::Playlist).count}
      expect{channel.playlists.select(:status).map &:privacy_status}.not_to change{GC.start; ObjectSpace.each_object(Yt::Playlist).count}
      expect{channel.playlists.limit(4).map &:id}.not_to change{GC.start; ObjectSpace.each_object(Yt::Playlist).count}
    end

    it 'accepts .select to fetch multiple parts with two HTTP calls' do
      expect(Net::HTTP).to receive(:start).exactly(1).times.and_call_original

      playlists = channel.playlists.select :snippet, :status, :content_details
      expect(playlists.map &:title).to be_present
      expect(playlists.map &:privacy_status).to be_present
      expect(playlists.map &:item_count).to be_present
    end

    it 'accepts .limit to only fetch some playlists' do
      expect(Net::HTTP).to receive(:start).exactly(1).times.and_call_original
      expect(channel.playlists.select(:snippet).limit(2).count).to be 2
    end
  end
end
