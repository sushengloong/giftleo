APP_CONFIG ||= YAML.load_file("#{Rails.root}/config/omniauth.yml")[Rails.env]

ENV['FACEBOOK_APP_ID'] = APP_CONFIG['facebook_app_id']
ENV['FACEBOOK_SECRET'] = APP_CONFIG['facebook_secret']
ENV['FACEBOOK_SCOPE'] = APP_CONFIG['facebook_scope']

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'], scope: ENV['FACEBOOK_SCOPE']
end
