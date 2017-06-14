class User < ApplicationRecord
  devise :trackable, :omniauthable, :timeoutable, omniauth_providers: [:google_oauth2]
  OAUTH_ALLOWED_DOMAINS = %w(betterment.com).freeze

  def self.from_omniauth(auth)
    if oauth_allowed_domain? auth
      user = find_or_initialize_by(email: auth.info.email)

      if user
        user.full_name = auth.info.name
        user.save
      end

      user
    end
  end

  class << self
    private

    def oauth_allowed_domain?(auth)
      OAUTH_ALLOWED_DOMAINS.any? { |domain| auth.extra.raw_info.hd == domain && auth.info.email =~ /@#{domain}\z/ }
    end
  end
end
