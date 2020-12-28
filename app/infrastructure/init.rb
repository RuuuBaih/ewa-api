# frozen_string_literal: true

folders = %w[database gateways messaging]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
