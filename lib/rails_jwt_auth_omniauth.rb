require 'rails_jwt_auth'
require 'rails_jwt_auth_omniauth/engine'
require 'rails_jwt_auth_omniauth/omniauth_manager'
require 'rails_jwt_auth_omniauth/omniauth_session'

module RailsJwtAuthOmniauth
  mattr_accessor :omniauth_configs
  self.omniauth_configs = {}

  def self.setup
    yield self
  end

  def self.omniauth(provider, *args)
    omniauth_configs[provider] = RailsJwtAuthOmniauth::OmniauthManager.new(provider, args)
  end
end