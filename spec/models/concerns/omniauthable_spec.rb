require 'rails_helper'

describe RailsJwtAuthOmniauth::Omniauthable do
  class DummyClass
    include RailsJwtAuthOmniauth::Omniauthable
  end

  describe '#methods' do
    it 'check from_omniauth' do
      klass = DummyClass
      expect { klass.from_omniauth(:foo) }.to(
          raise_exception RailsJwtAuthOmniauth::Omniauthable::NotImplementedMethod
      )
      klass.define_singleton_method(:from_omniauth) { |auth| auth }
      expect(klass.from_omniauth(:foo)).to eql :foo
    end
  end
end
