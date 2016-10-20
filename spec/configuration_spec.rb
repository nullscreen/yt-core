require 'spec_helper'

describe Yt::Configuration do
  describe 'can be set directly' do
    before { Yt.configuration.client_id = '123' }
    it { expect(Yt.configuration.client_id).to eq '123' }
  end

  describe 'can be set with Yt.configure' do
    before { Yt.configure{|config| config.client_id = '456'} }
    it { expect(Yt.configuration.client_id).to eq '456' }
  end

  describe 'can be set through environment variables' do
    before { Yt.instance_variable_set :@configuration, nil }
    before { ENV['YT_CLIENT_ID'] = '789' }
    it { expect(Yt.configuration.client_id).to eq '789' }
  end

  describe 'gives priority to Yt.configure over environment variables' do
    before { Yt.configure{|config| config.client_id = '456'} }
    before { ENV['YT_CLIENT_ID'] = '789' }
    it { expect(Yt.configuration.client_id).to eq '456' }
  end
end
