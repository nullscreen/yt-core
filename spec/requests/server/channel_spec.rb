require 'spec_helper'

describe Yt::Channel do
  before(:all) do
    Yt.configuration.api_key = ENV['YT_SERVER_API_KEY']
    Yt.configuration.client_id = ''
    Yt.configuration.client_secret = ''
  end

  let(:existing_id)    { 'UCwCnUcLcb9-eSrHa_RQGkQQ' }
  let(:unknown_id)     { 'UC-not-a-valid-id-_RQGkQ' }
  let(:terminated_id)  { 'UCKe_0fJtkT1dYnznt_HaTrA' }

  context 'given an existing channel ID' do
    subject(:channel) { Yt::Channel.new id: existing_id }

    specify 'snippet data can be fetched with one HTTP call' do
      expect(Net::HTTP).to receive(:start).once.and_call_original

      expect(channel.title).to eq 'Yt Test'
      expect(channel.description).to eq 'A YouTube channel to test the yt gem.'
      expect(channel.published_at).to eq Time.parse('2014-05-02 20:12:57 UTC')
      expect(channel.thumbnail_url).to be_a String
    end

    specify 'status data can be fetched with one HTTP call' do
      expect(Net::HTTP).to receive(:start).once.and_call_original

      expect(channel.privacy_status).to eq 'public'
      expect(channel.is_linked).to be true
      expect(channel.long_upload_status).to eq 'longUploadsUnspecified'
    end

    specify 'multiple data can be fetched with one HTTP call using select' do
      expect(Net::HTTP).to receive(:start).once.and_call_original

      expect(channel.select(:snippet, :status).title).to be
      expect(channel.select(:snippet, :status).privacy_status).to be
    end

    describe '#videos' do
      it 'returns the list of *public* videos limiting the number of HTTP requests' do
        expect(Net::HTTP).to receive(:start).once.and_call_original

        videos = channel.videos

        expect(videos).to be_present
        expect(videos).to all( be_a Yt::Video )
      end

      it 'accepts .select to fetch multiple parts with one HTTP call' do
        expect(Net::HTTP).to receive(:start).once.and_call_original

        videos = channel.videos.select :snippet

        expect(videos).to be_present
        expect(videos.map &:title).to be
      end
    end
  end

  context 'given an unknown channel ID' do
    subject(:channel) { Yt::Channel.new id: unknown_id }

    specify 'raises Yt::Errors::NoItems upon accessing its data' do
      expect{channel.title}.to raise_error Yt::Errors::NoItems
    end
  end

  context 'given multiple channel IDs' do
    let(:ids) { [existing_id, unknown_id, terminated_id] }
    subject(:relation) { Yt::Channel.where id: ids }

    it 'returns a list of channels limiting the number of HTTP requests' do
      expect(Net::HTTP).to receive(:start).once.and_call_original

      channels = relation

      expect(channels).to be_present
      expect(channels).to all( be_a Yt::Channel )
    end

    it 'only includes existing channels, ignoring the other :id' do
      expect(Net::HTTP).to receive(:start).once.and_call_original

      channels = relation

      expect(channels).to be_present
      expect(channels.map &:id).to eq [existing_id]
    end

    it 'accepts .select to fetch multiple parts with one HTTP call' do
      expect(Net::HTTP).to receive(:start).once.and_call_original

      channels = relation.select :snippet

      expect(channels).to be_present
      expect(channels.map &:title).to be
    end
  end
end
