# frozen_string_literal: true

# don't move the order, spec helper should be first require
require_relative '../spec/helpers/spec_helper'
require_relative '../app/infrastructure/database/init'
require 'yaml'

include Ewa
include Ewa::Database
include Restaurant
include Repository

config = YAML.safe_load(File.read('config/secrets.yml'))
token = config['development']['GMAP_TOKEN']
cx = config['development']['CX']

# check update status (create為first time, 而後為5次才打一次api 更新)

# get poi entity from db (use id 1 to test)
rest_entity = Repository::RestaurantDetails.find_by_rest_id(1)
status = Repository::RestaurantDetails.check_update_click_status(1, 5)

# check if first time update or clicks above 5 times
if rest_entity.google_rating.nil? && !status
  # get gmap related info
  rest_detail_entity = RestaurantDetailMapper.new(rest_entity, token).gmap_place_details
  # puts rest_detail_entity.inspect

  # get rebuilt repo entity
  # here will auto update click數量
  # update(entity, first_time_or_not)
  repo_entity = Repository::RestaurantDetails.update(rest_detail_entity, true)
  puts repo_entity.inspect
elsif status
  # get rebuilt repo entity
  # here will auto update click數量
  # update(entity, first_time_or_not)
  rest_detail_entity = RestaurantDetailMapper.new(rest_entity, token).gmap_place_details
  # update cover_pictures as well
  trim_name = rest_detail_entity.name.gsub(' ', '')
  cover_pics = CoverPictureMapper.new(token, cx, trim_name).cover_picture_lists
  new_cover_pic_entities = CoverPictureMapper::BuildCoverPictureEntity.new(cover_pics).build_entity
  cov_pic_repo_entities = Repository::CoverPictures.db_update(new_cover_pic_entities, rest_detail_entity.id)
  puts cov_pic_repo_entities.inspect

  repo_entity = Repository::RestaurantDetails.update(rest_detail_entity, false)
  puts repo_entity.inspect
else
  # it will return the clicks of that restaurant entity
  Repository::RestaurantDetails.update_click(1)
end

# update clicks

# puts ret
# puts ret.inspect

# puts ret.attributes
