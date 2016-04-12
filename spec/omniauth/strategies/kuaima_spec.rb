require 'spec_helper'

describe OmniAuth::Strategies::KuaiMa do

  let(:access_token) { double('AccessToken') }
  let(:parsed_response) { double('ParsedResponse') }
  let(:response) { double('Response', parsed: parsed_response) }

  let(:enterprise_site)           { 'https://some.other.site.com/api/v3' }
  let(:enterprise_authorize_url)  { '/oauth/authorize' }
  let(:enterprise_token_url)      { '/oauth/access_token' }

  let(:kuaima_service) { OmniAuth::Strategies::KuaiMa.new({}) }
  let(:enterprise) do
    OmniAuth::Strategies::KuaiMa.new('KUAIMA_KEY', 'KUAIMA_SECRET',
                                         client_options: {
                                             site: enterprise_site,
                                             authorize_url: enterprise_authorize_url,
                                             token_url: enterprise_token_url
                                         },
                                         redirect_url: 'http://localhost:9292/callback_url'
    )
  end

  subject { kuaima_service }

  before(:each) do
    allow(subject).to receive(:access_token).and_return(access_token)
  end

  describe 'client options' do
    context 'with defaults' do
      subject { kuaima_service.options.client_options }

      its(:site) { is_expected.to eq 'https://i.kuai.ma' }
      its(:authorize_url) { is_expected.to eq '/oauth/authorize' }
      its(:token_url) { is_expected.to eq '/oauth/access_token' }
    end

    context 'with override' do
      subject { enterprise.options.client_options }

      its(:site) { is_expected.to eq enterprise_site }
      its(:authorize_url) { is_expected.to eq enterprise_authorize_url }
      its(:token_url) { is_expected.to eq enterprise_token_url }
    end
  end

  describe 'redirect_url' do
    context 'with defaults' do
      subject { kuaima_service.options }
      its(:redirect_url) { is_expected.to be_nil }
    end

    context 'with customs' do
      subject { enterprise.options }
      its(:redirect_url) { is_expected.to eq 'http://localhost:9292/callback_url' }
    end
  end

  describe '#raw_info' do
    it 'sent request to current user endpoint' do
      expect(access_token).to receive(:get).with('/oauth/v1/user').and_return(response)
      expect(subject.raw_info).to eq(parsed_response)
    end
  end
end
