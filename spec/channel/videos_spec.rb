require 'spec_helper'

describe 'Yt::Channel#videos', :server do
  subject(:channel) { Yt::Channel.new attrs }

  context 'given an existing channel ID' do
    let(:attrs) { {id: $existing_channel_id} }

    it 'returns the list of *public* videos of the channel' do
      expect(channel.videos).to all( be_a Yt::Video )
    end

    it 'does not make any HTTP requests unless iterated' do
      expect(Net::HTTP).not_to receive(:start)
      channel.videos
    end

    it 'makes as many HTTP requests as the number of videos divided by 50' do
      expect(Net::HTTP).to receive(:start).once.and_call_original
      channel.videos.map &:id
    end

    it 'reuses the previous HTTP response if the request is the same' do
      expect(Net::HTTP).to receive(:start).once.and_call_original
      channel.videos.map &:id
      channel.videos.map &:id
    end

    it 'makes a new HTTP request if the request has changed' do
      expect(Net::HTTP).to receive(:start).exactly(3).times.and_call_original
      channel.videos.map &:id
      channel.videos.select(:id, :snippet).map &:title
    end

    it 'allocates at most one Yt::Relation object, no matter the requests' do
      expect{channel.videos}.to change{ObjectSpace.each_object(Yt::Relation).count}
      expect{channel.videos}.not_to change{ObjectSpace.each_object(Yt::Relation).count}
    end

    it 'allocates at most 50 Yt::Video object, no matter the requests' do
      expect{channel.videos.map &:id}.to change{GC.start; ObjectSpace.each_object(Yt::Video).count}
      expect{channel.videos.map &:id}.not_to change{GC.start; ObjectSpace.each_object(Yt::Video).count}
      expect{channel.videos.select(:status).map &:privacy_status}.not_to change{GC.start; ObjectSpace.each_object(Yt::Video).count}
      expect{channel.videos.limit(4).map &:id}.not_to change{GC.start; ObjectSpace.each_object(Yt::Video).count}
    end

    it 'accepts .select to fetch multiple parts with two HTTP calls' do
      expect(Net::HTTP).to receive(:start).twice.and_call_original

      videos = channel.videos.select :snippet, :status, :statistics, :content_details
      expect(videos.map &:title).to be_present
      expect(videos.map &:privacy_status).to be_present
      expect(videos.map &:view_count).to be_present
      expect(videos.map &:duration).to be_present
    end

    it 'accepts .limit to only fetch some videos' do
      expect(Net::HTTP).to receive(:start).twice.and_call_original
      expect(channel.videos.select(:snippet).limit(3).count).to be 3
      expect(channel.videos.select(:snippet).limit(3).count).to be 3
    end
  end

  context 'given a channel with more than 500 public videos' do
    let(:attrs) { {id: $gigantic_channel_id} }

    it 'returns at most 500 videos' do
      expect(channel.videos.count).to eq 500
    end
  end
end
