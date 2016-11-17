require 'spec_helper'

describe 'Yt::Authentication#url' do
  subject(:auth) { Yt::Authentication.new attrs }
  let(:redirect_uri) { 'https://example.com/auth' }

  context 'given a redirect_uri and a set of scopes' do
    let(:scopes) { %w(youtube yt-analytics.readonly) }
    let(:attrs) { {redirect_uri: redirect_uri, scopes: scopes} }

    it 'returns the URL for users to authenticate an app for those scopes' do
      expect(auth.url).to start_with 'https://accounts.google.com/o/oauth2/auth'
    end
  end
end
