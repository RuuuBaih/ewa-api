# frozen_string_literal: true

folders = %w[application infrastructure domain presentation]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
