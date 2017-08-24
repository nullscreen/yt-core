require 'spec_helper'

describe 'Yt::Response#get' do
  subject(:response) { Yt::Response.new options, &block }

  context 'given a request that requires an access token' do
    let(:options) { {item_class: Yt::Channel} }
    let(:block) { Proc.new{get '/youtube/v3/channels', mine: true, part: 'id'} }

    context 'given access token is missing and refresh token is valid', :account do
      it 'works' do
        expect{response.run}.not_to raise_error
      end
    end

    context 'given access token is expired and refresh token is valid', :account do
      before { Yt.configuration.access_token = '--invalid-token--' }
      before { Yt.configuration.refresh_token = ENV['YT_ACCOUNT_REFRESH_TOKEN'] }

      it 'works' do
        expect{response.run}.not_to raise_error
      end
    end

    context 'given access token and refresh token are invalid', :account do
      before { Yt.configuration.access_token = '--invalid-token--' }
      before { Yt.configuration.refresh_token = '--invalid-token--' }

      it 'raises an error' do
        expect{response.run}.to raise_error Yt::HTTPError
      end
    end

    context 'given access token and refresh token are missing', :account do
      before { Yt.configuration.access_token = nil }
      before { Yt.configuration.refresh_token = nil }

      it 'raises an error' do
        expect{response.run}.to raise_error Yt::HTTPError
      end
    end
  end
end
