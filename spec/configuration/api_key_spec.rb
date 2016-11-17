require 'spec_helper'

describe 'Yt::Configuration#api_key' do
  describe 'can be set directly' do
    before { Yt.configuration.api_key = '123' }
    it { expect(Yt.configuration.api_key).to eq '123' }
  end

  describe 'can be set with Yt.configure' do
    before { Yt.configure{|config| config.api_key = '456'} }
    it { expect(Yt.configuration.api_key).to eq '456' }
  end

  describe 'can be set through environment variables' do
    before { Yt.instance_variable_set :@configuration, nil }
    before { ENV['YT_API_KEY'] = '789' }
    it { expect(Yt.configuration.api_key).to eq '789' }
  end

  describe 'gives priority to Yt.configure over environment variables' do
    before { Yt.configure{|config| config.api_key = '456'} }
    before { ENV['YT_API_KEY'] = '789' }
    it { expect(Yt.configuration.api_key).to eq '456' }
  end
end
