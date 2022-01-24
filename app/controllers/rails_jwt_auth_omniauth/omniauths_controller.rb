module RailsJwtAuthOmniauth
  class OmniauthsController < ApplicationController
    include RailsJwtAuth::RenderHelper

    def callback
      puts '*' * 100
      puts auth_hash
      user = RailsJwtAuth.model_name.constantize.from_omniauth(auth_hash)
      se = RailsJwtAuthOmniauth::OmniauthSession.new(user)

      if se.generate!
        render_session se.jwt, se.user
      else
        render_422 se.errors.details
      end
    end

    protected

    def auth_hash
      request.env['omniauth.auth']
    end
  end
end