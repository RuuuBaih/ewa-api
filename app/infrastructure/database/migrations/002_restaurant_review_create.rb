# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:reviews) do
      primary_key :review_id
      
      String :author_name
      String :profile_photo_url
      String :relative_time_description
      String :text

      DateTime :created_at
      DateTime :updated_at
    end
  end
end