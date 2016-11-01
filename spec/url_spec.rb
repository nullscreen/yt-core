require 'spec_helper'

describe Yt::URL do
  subject(:url) { Yt::URL.new text }

  context 'given a YouTube video URL' do
    let(:id) { 'gknzFj_0vvY' }
    let(:canonical) { "https://www.youtube.com/watch?v=#{id}" }

    describe 'in the long form' do
      let(:text) { "youtube.com/watch?v=#{id}" }
      it {expect(url.kind).to eq :video }
      it {expect(url.id).to eq id }
      it {expect(url.canonical).to eq canonical }
    end

    describe 'in the short form' do
      let(:text) { "https://youtu.be/#{id}" }
      it {expect(url.kind).to eq :video }
      it {expect(url.id).to eq id }
      it {expect(url.canonical).to eq canonical }
    end

    describe 'in the embed form' do
      let(:text) { "https://www.youtube.com/embed/#{id}" }
      it {expect(url.kind).to eq :video }
      it {expect(url.id).to eq id }
      it {expect(url.canonical).to eq canonical }
    end

    describe 'in the "v" form' do
      let(:text) { "https://www.youtube.com/v/#{id}" }
      it {expect(url.kind).to eq :video }
      it {expect(url.id).to eq id }
      it {expect(url.canonical).to eq canonical }
    end

    describe 'embedded in a playlist' do
      let(:text) { "youtube.com/watch?v=#{id}&list=LLxO1tY8h1AhOz0T4ENwmpow" }
      it {expect(url.kind).to eq :video }
      it {expect(url.id).to eq id }
      it {expect(url.canonical).to eq canonical }
    end
  end

  context 'given a YouTube channel URL' do
    describe 'in the long form' do
      let(:id) { 'UCxO1tY8h1AhOz0T4ENwmpow' }
      let(:text) { "http://youtube.com/channel/#{id}" }
      it {expect(url.kind).to eq :channel }
      it {expect(url.id).to eq id }
      it {expect(url.username).to be_nil }
      it {expect(url.canonical).to eq "https://www.youtube.com/channel/#{id}" }
    end

    describe 'in the short form' do
      let(:username) { 'Fullscreen' }
      let(:text) { "https://www.youtube.com/#{username}" }
      it {expect(url.kind).to eq :channel }
      it {expect(url.id).to be_nil }
      it {expect(url.username).to eq username }
      it {expect(url.canonical).to eq "https://www.youtube.com/user/#{username}" }
    end

    describe 'in the user’s channel form' do
      let(:username) { 'Fullscreen' }
      let(:text) { "https://www.youtube.com/user/#{username}" }
      it {expect(url.kind).to eq :channel }
      it {expect(url.id).to be_nil }
      it {expect(url.username).to eq username }
      it {expect(url.canonical).to eq "https://www.youtube.com/user/#{username}" }
    end
  end

  context 'given a YouTube playlist URL' do
    describe 'in the long form' do
      let(:id) { 'LLxO1tY8h1AhOz0T4ENwmpow' }
      let(:text) { "youtube.com/playlist?list=#{id}" }
      it {expect(url.kind).to eq :playlist }
      it {expect(url.id).to eq id }
      it {expect(url.canonical).to eq "https://www.youtube.com/playlist?list=#{id}" }
    end
  end

  context 'given a valid YouTube URL' do
    describe 'prints out a compact version of the object' do
      let(:text) { 'youtube.com/watch?v=gknzFj_0vvY' }
      it {expect(url.inspect).to eq '#<Yt::URL @kind=video @id=gknzFj_0vvY>'}
    end

    describe 'works with a trailing slash' do
      let(:text) { 'https://www.youtube.com/user/Fullscreen/' }
      it {expect(url.kind).to eq :channel }
    end

    describe 'works with extra spaces' do
      let(:text) { '  https://www.youtube.com/v/gknzFj_0vvY ' }
      it {expect(url.kind).to eq :video }
    end
  end

  context 'given a non-YouTube URL' do
    let(:text) { 'any-string' }
    it {expect(url.kind).to eq :unknown }
  end
end
