require 'spec_helper'

describe 'Yt::Authentication#tokens' do
  subject(:auth) { Yt::Authentication.new attrs }
  let(:redirect_uri) { 'https://example.com/auth' }

  context 'given a redirect_uri and a valid code' do
    let(:code) { '1234' }
    let(:attrs) { {redirect_uri: redirect_uri, code: code} }

    # Note: The result **cannot** be tested automatically since the OAuth
    # flow requires user to accept the conditions. Therefore, we are simply
    # testing the method itself here, not the result.
    it 'returns the access and refresh token for the user' do
      expect(auth.tokens).to be_a Hash
    end
  end
end
