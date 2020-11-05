# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:reviews) do
      primary_key :article_id
      # 等阿嚕弄完之後要加foreign key
      String :restaurant_name, unique: true
      String :link

      DateTime :created_at
      DateTime :updated_at
    end
  end
end