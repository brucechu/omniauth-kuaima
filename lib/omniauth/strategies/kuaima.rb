
require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class KuaiMa < OmniAuth::Strategies::OAuth2

      option :client_options, {
          site: 'https://i.kuai.ma',
          authorize_url: '/oauth/authorize',
          token_url: '/oauth/access_token'
      }

      option :redirect_url

      uid { raw_info['id'].to_s }

      info do
        {
            name:     raw_info['code'],
            username: raw_info['full_name'],
            email:    raw_info['email']
        }
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get('/oauth/v1/user').parsed
      end

      private

      def callback_url
        options.redirect_url || (full_host + script_name + callback_path)
      end
    end
  end
end


OmniAuth.config.add_camelization 'kuaima', 'KuaiMa'
