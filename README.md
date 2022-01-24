# RailsJwtAuthOmniauth

Addon for rails_jwt_auth gem. Add omniauth capabilities to gem

> This gem require rails_jwt_auth 2.x version

## Table of Contents

- [Installation](#installation)
- [Configuration](#configuration)
- [Modules](#modules)
- [ORMs support](#orms-support)
- [Omniauth](#omniauth)
- [Testing](#testing-rspec)
- [License](#license)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_jwt_auth'
gem 'rails_jwt_auth_omniauth'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install rails_jwt_auth_omniauth
```

## Configuration

You can edit configuration options into `config/initializers/rails_jwt_auth_omniauth.rb` file created by generator.

| Option                                    | Default value              | Description                                                            |
| ----------------------------------        | ----------------           | ---------------------------------------------------------------------- |
| omniauth                                  | `nil`                      | Allow add omniauths providers                                          |

## Modules

It's composed of 1 module:

| Module        | Description                                                                                                     |
| ------------- | --------------------------------------------------------------------------------------------------------------- |
| Omniauthable  | Allows you to define behaviours for omniauth sessions                                                           |

## ORMs Support

**ActiveRecord**

```ruby
# app/models/user.rb
class User < ApplicationRecord
  include RailsJwtAuth::Authenticatable
  include RailsJwtAuthOmniath::Omniauthable

  validates :email, presence: true,
                    uniqueness: true,
                    format: URI::MailTo::EMAIL_REGEXP
end
```

**Mongoid**

```ruby
class User
  include Mongoid::Document
  include RailsJwtAuth::Authenticatable
  include RailsJwtAuthOmniauth::Omniauthable

  field :email, type: String

  validates :email, presence: true,
                    uniqueness: true,
                    format: URI::MailTo::EMAIL_REGEXP
end
```

## Omniauth

Allow you to use omniauth providers to login in the platform. Rails_jwt_auth_omniauth will not save `auth_token`
from providers and only will create a jwt session.

To configure omniauth clients:

Select a provider and define it in your Gemfile and install:

```ruby
# Gemfile
gem 'omniauth' # Required if omniauth is not dependency in your provider gem
gem 'omniauth-google-oauth2'
```

Configuration providers:

```ruby
# config/initialize/rails_jwt_auth_omniauth.rb
RailsJwtAuthOmniauth.setup do |config|
  # ...
  config.omniauth :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {
    provider_ignores_state: true, # this is neccesary for CSRF in extenals requests
    scope: 'userinfo.email, userinfo.profile'
  }
  # You can add multiple omniauth configurations of each provider
end
```

In router:

```ruby
#cofig/router.rb
post '/auth/:provider/callback', to: 'rails_jwt_auth_omniauth/omniauths#callback' # If not use generator
```

In model:

```ruby
include RailsJwtAuthOmniauth::Omniauthable
def self.from_omniauth(auth)
  # Define logic to search or create User. This method should return a user to be logged
  # auth.provider: provider that has processed request
  # auth['info']: User data from provider
end
```

In js you will need a library to get auth_code from provider to pass the code to the backend:

```js
  // Ej: vue-google-oauth2
  const authCode = await this.$gAuth.getAuthCode()
  const response = await this.$http.post(
    'http://yout-backend-server-api/auth/google_oauth2/callback',
    { code: authCode }
  )
```

## Locales

Copy `config/locales/en.yml` into your project `config/locales` folder and edit it.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
