# frozen_string_literal: true

folders = %w[controllers infrastructure domain]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
