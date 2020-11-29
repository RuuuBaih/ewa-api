# frozen_string_literal: true

folders = %w[controllers restaurant_actions restaurant_others]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end