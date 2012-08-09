require 'cgi'

require "rubygems"
require "bundler/setup"

require 'times_wire'
require 'bitly'
require 'json'
require 'awesome_print'
require 'hashie'
require 'rest_client'
require 'nokogiri'
require 'mongo_mapper'
require "addressable/uri"


$LOAD_PATH << File.dirname(__FILE__)

module NewsMonster
	autoload :Config, 			'news_monster/config'
	autoload :Article, 			'news_monster/article'
	autoload :ArticlesService,  'news_monster/articles_service'
	autoload :CompositeArticle, 'news_monster/composite_article'
end

NewsMonster::Config.load


NewsMonster::ArticlesService.new.fetch_latest
