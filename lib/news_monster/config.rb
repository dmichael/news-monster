require 'yaml'

module NewsMonster
	class Config
		def self.config
      @config ||= Hashie::Mash.new(
        YAML.load_file(File.open File.dirname(__FILE__) + "/news_monster.yml")
      )
    end

    def self.load
      MongoMapper.database = config.database
      Bitly.use_api_version_3
      TimesWire::Base.api_key = config.times_api.newswire_key
    end

  end
end