# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:articles) do
      primary_key :id

      String :restaurant_name, unique: true
      String :link

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
