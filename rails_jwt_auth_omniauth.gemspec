$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'rails_jwt_auth_omniauth/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'rails_jwt_auth_omniauth'
  s.version     = RailsJwtAuthOmniauth::VERSION
  s.authors     = ['jmjurado23']
  s.email       = ['jmjurado23@gmail.com']
  s.homepage    = 'https://github.com/jmjurado23/rails_jwt_auth_omniauth'
  s.summary     = 'Rails jwt authentication Omniauthable.'
  s.description = 'Addon for rails_jwt_auth gem. Add omniauth capabilities to gem'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails_jwt_auth', '~> 2.0.3'
  s.add_dependency 'omniauth', '~> 2.0'
end
