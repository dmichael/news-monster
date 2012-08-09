
module NewsMonster
    class ArticlesService

        # Grabs the latest news articles and saves them to local persistance
        def fetch_latest(options = {})
            limit = options[:limit] || 15 # 15 is the default of the lib
            wire  = options[:wire] || 'nyt'

            TimesWire::Item.latest(wire, limit).each do |item|
                next if Article.exist?(url: item.url)
                puts item.title

                composite = CompositeArticle.from_item(item)
                
                Article.create composite
            end
        end

    end
end