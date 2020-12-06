# frozen_string_literal: true

folders = %w[controllers services requests]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
