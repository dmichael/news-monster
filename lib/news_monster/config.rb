require 'yaml'

module NewsMonster
	module Config
		def config
      @config ||= Hashie::Mash.new(
        YAML.load_file(File.open File.dirname(__FILE__) + "/news_monster.yml")
      )
    end

    def load
      # MongoMapper.database    = config.database
      TimesWire::Base.api_key = config.nytimes.newswire_key
      Bitly.use_api_version_3
    end

  end
end