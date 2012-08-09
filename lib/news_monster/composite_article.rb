module NewsMonster
    class CompositeArticle < Hashie::Mash

        def self.from_item(item)
            article = self.new JSON.parse(JSON.generate item)
            
            article.fetch_short_url
            article.fetch_body

            article
        end
        
        # Shorten is the only call that returns the nyt.ms domain, lookup, which is batch does not
        def fetch_short_url
            bitly = Bitly.new(Config.config.bitly.username, Config.config.bitly.api_key)
            self.short_url = bitly.shorten(url).short_url
        end

        def fetch_body
            execute_fetch_body self.url
        end

        def execute_fetch_body(uri, body = "", visited = [])
            uri = Addressable::URI.parse uri
            doc = Nokogiri::HTML RestClient.get(uri.to_s)
            # let's not loop infinitely
            visited << uri.to_s
            
            body_selector       = 'p[itemprop = "articleBody"], div[class = "entry-content"]'
            pagination_selector = '//ul[@id="pageNumbers"]/li/a/@href'

            body = doc.css(body_selector).reduce(body) {|reduced, node| 
                reduced << node.to_html 
            }

            doc.css(pagination_selector).each do |node|
                link = Addressable::URI.parse node.text
                normalize_link!(uri, link)
                remove_unwanted_params!(link)

                unless visited.include?(link.to_s)
                    body = execute_fetch_body(link.to_s, body, visited) 
                end
            end

            self.body = body
        end

        # Select only the pagewanted > 1 from the query params
        def remove_unwanted_params!(link)    
            query = CGI::parse(link.query).select { |k, v| k == "pagewanted" && !v.include?("1")}
            link.query_values = query.empty? ? nil : query
        end

        # normalize the page link - some are set relatively
        def normalize_link!(uri, link)
            link.scheme ||= uri.scheme
            link.host   ||= uri.host
        end
    end
end