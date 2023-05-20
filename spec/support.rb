unless defined?(Rack::Session::SessionId)
  module Rack
    module Session
      class SessionId
        ID_VERSION = 2

        attr_reader :public_id

        def initialize(public_id)
          @public_id = public_id
        end

        alias to_s public_id

        def empty?
          false
        end

        def inspect
          public_id.inspect
        end

        def private_id
          "#{ID_VERSION}::#{hash_sid(public_id)}"
        end

        private

        def hash_sid(value)
          "test_hash_from:#{value}"
        end
      end
    end
  end
end

unless defined?(ActionDispatch::Session::AbstractSecureStore)
  module ActionDispatch
    module Session
      class AbstractSecureStore
        ENV_SESSION_OPTIONS_KEY = 'rack.session.options'.freeze
        DEFAULT_OPTIONS = {
          key: '_session_id',
          path: '/',
          domain: nil,
          expire_after: nil,
          secure: false,
          httponly: true,
          cookie_only: true
        }.freeze

        def initialize(app, options = {})
          @app = app
          @default_options = DEFAULT_OPTIONS.dup.merge(options)
          @key = @default_options[:key]
          @cookie_only = @default_options[:cookie_only]
        end

        private

        def generate_sid
          Rack::Session::SessionId.new(rand(999..9999).to_s(16))
        end
      end
    end
  end
end

unless defined?(Rails)
  require 'logger'

  module Rails
    def self.logger
      @logger ||= Logger.new('/dev/null')
    end
  end
end
