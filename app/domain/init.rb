# frozen_string_literal: true

# folders = %w[restaurant_options restaurants]
folders = %w[restaurants restaurant_options]

folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
