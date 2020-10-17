# frozen_string_literal: false

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/pix_keyword_api'

include JustRuIt

KEYWORDS_EN_test = 'Gucci'
KEYWORDS_CN_test = '螺絲瑪麗'
KEYWORDS_EN_list = ["GUCCI","巴黎迪士尼","古董","精品","義大利","歐洲自助","東京","下午茶","VOGUE","Snoopy","sur","outlet","巴黎","咖啡","甜點","日本","FacebookSEO","Noir Gucci Ceintures","時尚潮流-時尚單品","Facebook讚好"].freeze
KEYWORDS_CN_list = ["螺絲瑪麗","義大利麵","螺絲瑪麗意麵坊","Rose Mary","Rose Mary螺絲瑪麗意麵坊","中山捷運"]

describe 'Tests PIXNET API library' do
  describe 'keywords' do

    it 'supports yaml inputs' do
      _(FlipFlap.input_formats).must_include 'yaml'
    end

    it 'HAPPY: should create correct English keyword file ' do
      _(PixKeywordApi.new(KEYWORDS_EN_test).keyword_lists).must_equal KEYWORDS_EN_list
      _(project.git_url).must_equal CORRECT['git_url']
    end

    it 'SAD: should raise exception on incorrect project' do
      _(proc do
        CodePraise::GithubApi.new(GH_TOKEN).project('soumyaray', 'foobar')
      end).must_raise CodePraise::GithubApi::Errors::NotFound
    end

    it 'SAD: should raise exception when unauthorized' do
      _(proc do
        CodePraise::GithubApi.new('BAD_TOKEN').project('soumyaray', 'foobar')
      end).must_raise CodePraise::GithubApi::Errors::Unauthorized
    end
  end

  describe 'Contributor information' do
    before do
      @project = CodePraise::GithubApi.new(GH_TOKEN)
                                      .project(USERNAME, PROJECT_NAME)
    end

    it 'HAPPY: should recognize owner' do
      _(@project.owner).must_be_kind_of CodePraise::Contributor
    end

    it 'HAPPY: should identify owner' do
      _(@project.owner.username).wont_be_nil
      _(@project.owner.username).must_equal CORRECT['owner']['login']
    end

    it 'HAPPY: should identify contributors' do
      contributors = @project.contributors
      _(contributors.count).must_equal CORRECT['contributors'].count

      usernames = contributors.map(&:username)
      correct_usernames = CORRECT['contributors'].map { |c| c['login'] }
      _(usernames).must_equal correct_usernames
    end
  end
end