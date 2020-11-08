# frozen_string_literal: true

folders = %w[models controllers infrastructure]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
