module NewsMonster
    class Article
        include MongoMapper::Document

        key :updated_date,   Time
        key :created_date,   Time
        key :published_date, Time 
    end
end