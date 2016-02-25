Rails.application.config.middleware.use OmniAuth::Builder do
  app_id     = Rails.application.secrets.facebook["app_id"]
  app_secret = Rails.application.secrets.facebook["app_secret"]

  provider :facebook, app_id, app_secret, scope: "email"
end
