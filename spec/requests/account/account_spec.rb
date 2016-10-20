require 'spec_helper'

describe Yt::Account do
  before(:all) do
    Yt.configuration.api_key = ''
    Yt.configuration.client_id = ENV['YT_ACCOUNT_CLIENT_ID']
    Yt.configuration.client_secret = ENV['YT_ACCOUNT_CLIENT_SECRET']
  end

  subject(:account) { Yt::Account.new refresh_token: ENV['YT_ACCOUNT_REFRESH_TOKEN'] }

  describe '#videos' do
    it 'returns the list of *public/unlisted/private* videos limiting the number of HTTP requests' do
      expect(Net::HTTP).to receive(:start).once.with('accounts.google.com', 443, use_ssl: true).and_call_original
      expect(Net::HTTP).to receive(:start).once.with('www.googleapis.com', 443, use_ssl: true).and_call_original

      videos = account.videos

      expect(videos).to be_present
      expect(videos).to all( be_a Yt::Video )
    end

    it 'accepts .select to fetch multiple parts with one HTTP call' do
      expect(Net::HTTP).to receive(:start).once.with('accounts.google.com', 443, use_ssl: true).and_call_original
      expect(Net::HTTP).to receive(:start).once.with('www.googleapis.com', 443, use_ssl: true).and_call_original

      videos = account.videos.select :snippet

      expect(videos).to be_present
      expect(videos.map &:title).to be
    end
  end
end
