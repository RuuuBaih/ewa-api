# frozen_string_literal: true

folders = %w[application infrastructure domain]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
