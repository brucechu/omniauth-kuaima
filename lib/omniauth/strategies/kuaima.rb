require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Kuaima < OmniAuth::Strategies::OAuth2

      # Give your strategy a name.
      option :name, "kuaima"

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, {:site => "https://i.kuai.ma", :authorize_url => 'https://i.kuai.ma/oauth/authorize', :token_url => 'https://i.kuai.ma/oauth/access_token'}

      uid { raw_info['id'] }

      info do
        {
          :nickname => raw_info['full_name'],
          :email => raw_info['email'],
          :name => raw_info['code']
        }
      end

      extra do
        {:raw_info => raw_info}
      end

      def raw_info
        access_token.options[:mode] = :query
        @raw_info ||= access_token.get('oauth/v1/user').parsed
      end

    end
  end
end

OmniAuth.config.add_camelization 'kuaima', 'Kuaima'
