# frozen_string_literal: true

require_relative '../init'

require 'econfig'
require 'shoryuken'

# Shoryuken worker class to click restaurants in parallel
class ClickWorker
  extend Econfig::Shortcut
  Econfig.env = ENV['RACK_ENV'] || 'development'
  Econfig.root = File.expand_path('..', File.dirname(__FILE__))

  Shoryuken.sqs_client = Aws::SQS::Client.new(
    access_key_id: config.AWS_ACCESS_KEY_ID,
    secret_access_key: config.AWS_SECRET_ACCESS_KEY,
    region: config.AWS_REGION
  )

  include Shoryuken::Worker
  shoryuken_options queue: config.CLICK_QUEUE_URL, auto_delete: true

=begin   
  def perform(_sqs_msg, request)
    project = Ewa::Representer::Project
      .new(OpenStruct.new).from_json(request)
    Ewa::GitRepo.new(project).clone!
  rescue Ewa::GitRepo::Errors::CannotOverwriteLocalGitRepo
    puts 'CLICK EXISTS -- ignoring request'
  end 
=end

end