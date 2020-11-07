# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:restaurants) do
      primary_key :restaurant_id
      foreign_key :review_id, :reviews
      foreign_key :article_id, :articles

      String :name
      String :town
      Integer :money
      String :city
      String :telephone
      String :cover_img
      String :tags
      Float :pixnet_rating
      Float :google_rating
      String :open_hours

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
