# frozen_string_literal: true

require_relative '../app/models/mappers/article_mapper'
require 'yaml'

include Ewa
include Restaurant


article = ArticleMapper.new("RoseMary").the_newest_article
puts article 
ret = ArticleMapper::BuildArticleEntity.new(article).build_entity
#puts ret
puts ret.inspect

# puts ret.attributes

