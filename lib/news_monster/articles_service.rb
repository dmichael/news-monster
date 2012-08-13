
class RingBuffer < Array
  attr_reader :max_size

  def initialize(max_size, enum = nil)
    @max_size = max_size
    enum.each { |e| self << e } if enum
  end

  def <<(el)
    if self.size < @max_size || @max_size.nil?
      super
    else
      self.pop
      self.unshift(el)
    end
  end

  alias :push :<<
end

module NewsMonster
    class ArticlesService

        def dumbcache
            @cache ||= RingBuffer.new(45)
        end

        def archive_path
            File.join(File.dirname(__FILE__), "../../archive/#{Time.now.strftime('%Y/%m/%d')}")
        end

        # Grabs the latest news articles and saves them to local persistance
        def fetch_latest(options = {})
            limit = options[:limit] || 15 # 15 is the default of the lib
            wire  = options[:wire] || 'nyt'

            TimesWire::Item.latest(wire, limit).each do |item|
                next if dumbcache.include? item.url# Article.exist?(url: item.url)
                
                dumbcache << item.url
                puts item.title

                composite = CompositeArticle.from_item(item)
                
                #Article.create composite
                
                system "terminal-notifier -title \"#{composite.title.gsub('"','\'')}\" -open #{composite.short_url} -message \"#{composite.abstract.gsub('"','\'')}\""
                
                if NewsMonster.config.save_archive
                    file = File.join archive_path, "#{composite.global_hash}.json"
                    FileUtils.mkdir_p archive_path
                    File.open(file, 'w') {|f| f.write(JSON.generate(composite)) }
                end
            end
        rescue RuntimeError => e
            puts "Error with TimesWire: #{e.message}"
        end

    end
end