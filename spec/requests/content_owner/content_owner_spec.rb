require 'spec_helper'

describe Yt::ContentOwner do
  before(:all) do
    Yt.configuration.api_key = ''
    Yt.configuration.client_id = ENV['YT_PARTNER_CLIENT_ID']
    Yt.configuration.client_secret = ENV['YT_PARTNER_CLIENT_SECRET']
  end

  subject(:content_owner) { Yt::ContentOwner.new id: ENV['YT_PARTNER_ID'], refresh_token: ENV['YT_PARTNER_REFRESH_TOKEN'] }

  describe '#display_name' do
    it 'returns the display name limiting the number of HTTP requests' do
      expect(Net::HTTP).to receive(:start).once.with('accounts.google.com', 443, use_ssl: true).and_call_original
      expect(Net::HTTP).to receive(:start).once.with('www.googleapis.com', 443, use_ssl: true).and_call_original

      display_name = content_owner.display_name

      expect(display_name).to be_present
      expect(display_name).to be_a(String)
    end
  end

  describe '#partnered_channels' do
    it 'returns the list of partnered channels limiting the number of HTTP requests' do
      expect(Net::HTTP).to receive(:start).once.with('accounts.google.com', 443, use_ssl: true).and_call_original
      expect(Net::HTTP).to receive(:start).once.with('www.googleapis.com', 443, use_ssl: true).and_call_original

      channels = content_owner.partnered_channels

      expect(channels).to be_present
      expect(channels).to all( be_a Yt::Channel )
    end

    specify 'accepts .select to fetch multiple parts with one HTTP call' do
      expect(Net::HTTP).to receive(:start).once.with('accounts.google.com', 443, use_ssl: true).and_call_original
      expect(Net::HTTP).to receive(:start).once.with('www.googleapis.com', 443, use_ssl: true).and_call_original

      channels = content_owner.partnered_channels.select :status, :snippet

      expect(channels).to be_present
      expect(channels.map &:title).to be_present
      expect(channels.map &:privacy_status).to be_present
    end
  end
end
