# frozen_string_literal: true

require 'roda'
require 'econfig'

module Ewa
  # Configuration for the App
  class App < Roda
    plugin :environments

    extend Econfig::Shortcut
    Econfig.env = environment.to_s
    Econfig.root = '.'

    configure :development, :test do
      ENV['DATABASE_URL'] = "sqlite://#{config.DB_FILENAME}"
    end

    configure :production do
      # Set DATABASE_URL environment variable on production platform
    end

    configure do
      require 'sequel'
      DB = Sequel.connect(ENV['DATABASE_URL']) # rubocop:disable Lint/ConstantDefinitionInBlock

      def self.DB # rubocop:disable Naming/MethodName
        DB
      end
    end
  end
end