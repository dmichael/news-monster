#!/usr/bin/env ruby

require 'cgi'
require 'fileutils'

require 'rubygems'
require 'bundler/setup'

require 'times_wire'
require 'bitly'
require 'json'
require 'awesome_print'
require 'hashie'
require 'rest_client'
require 'nokogiri'
# require 'mongo_mapper'

require 'active_support/core_ext'

require 'addressable/uri'
require 'dante'

$LOAD_PATH << File.dirname(__FILE__)

module NewsMonster
	autoload :Config, 			'news_monster/config'
	autoload :Article, 			'news_monster/article'
	autoload :ArticlesService,  'news_monster/articles_service'
	autoload :CompositeArticle, 'news_monster/composite_article'

	extend Config

	def self.root
		File.join './..', File.dirname(__FILE__)
	end
end

NewsMonster.load


# opts: host, pid_path, port, daemonize, user, group
Dante.run('news-monster') do |opts|
	service = NewsMonster::ArticlesService.new
  	
	  while true do
		puts "Polling NYTimes ... "
		
		service.fetch_latest	
		
		sleep(30); puts "zzz ... "
	  end
end
