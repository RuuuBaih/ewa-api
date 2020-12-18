# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:towns) do
      primary_key :id

      Integer :page
      Integer : search_times

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
