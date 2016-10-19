require 'spec_helper'

describe Yt::ContentOwner do
  before(:all) do
    ENV['YT_API_KEY'] = ''
    ENV['YT_CLIENT_ID'] = ENV['YT_PARTNER_CLIENT_ID']
    ENV['YT_CLIENT_SECRET'] = ENV['YT_PARTNER_CLIENT_SECRET']
  end

  subject(:content_owner) { Yt::ContentOwner.new id: ENV['YT_PARTNER_ID'], refresh_token: ENV['YT_PARTNER_REFRESH_TOKEN'] }

  describe '#display_name' do
    it 'returns the display name limiting the number of HTTP requests' do
      expect(Net::HTTP).to receive(:start).once.with('accounts.google.com', 443, use_ssl: true).and_call_original
      expect(Net::HTTP).to receive(:start).once.with('www.googleapis.com', 443, use_ssl: true).and_call_original

      expect(content_owner.display_name).to be_present
      expect(content_owner.display_name).to be_a(String)
    end
  end

  describe '#partnered_channels' do
    it 'returns the list of partnered channels limiting the number of HTTP requests' do
      expect(Net::HTTP).to receive(:start).once.with('accounts.google.com', 443, use_ssl: true).and_call_original
      expect(Net::HTTP).to receive(:start).once.with('www.googleapis.com', 443, use_ssl: true).and_call_original

      expect(content_owner.partnered_channels).to be_present
      expect(content_owner.partnered_channels).to all( be_a Yt::Channel )
    end
  end
end
