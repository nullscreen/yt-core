require 'spec_helper'

describe Yt::Configuration do
  describe 'can be set directly' do
    before { Yt.configuration.log_level = 'devel' }
    it { expect(Yt.configuration.log_level).to eq 'devel' }
  end

  describe 'can be set with Yt.configure' do
    before { Yt.configure{|config| config.log_level = 'debug'} }
    it { expect(Yt.configuration.log_level).to eq 'debug' }
  end

  describe 'can be set through environment variables' do
    before { Yt.instance_variable_set :@configuration, nil }
    before { ENV['YT_LOG_LEVEL'] = 'info' }
    it { expect(Yt.configuration.log_level).to eq 'info' }
  end

  describe 'gives priority to Yt.configure over environment variables' do
    before { Yt.configure{|config| config.log_level = 'debug'} }
    before { ENV['YT_LOG_LEVEL'] = 'info' }
    it { expect(Yt.configuration.log_level).to eq 'debug' }
  end
end
