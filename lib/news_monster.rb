#!/usr/bin/env ruby

require 'cgi'

require 'rubygems'
require 'bundler/setup'

require 'times_wire'
require 'bitly'
require 'json'
require 'awesome_print'
require 'hashie'
require 'rest_client'
require 'nokogiri'
require 'mongo_mapper'
require 'addressable/uri'
require 'dante'

$LOAD_PATH << File.dirname(__FILE__)

module NewsMonster
	autoload :Config, 			'news_monster/config'
	autoload :Article, 			'news_monster/article'
	autoload :ArticlesService,  'news_monster/articles_service'
	autoload :CompositeArticle, 'news_monster/composite_article'
end

NewsMonster::Config.load



Dante.run('news-monster') do |opts|
  # opts: host, pid_path, port, daemonize, user, group
  while true do
  	puts "Polling NYTimes ... "
	NewsMonster::ArticlesService.new.fetch_latest	
	puts "zzz ... "
	sleep(30)
  end
end
