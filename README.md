NewsMonster!
=============

NewsMonster is a Ruby library for polling the NYT Times Newswire API for articles as they are published, storing the results in a MongoDB. It was developed so that a corpus of current NYTimes articles could be built up for analysis.

The lib also just so happens to visit the URL specified in the response, parse the content, and visit Bitly for the nyt.ms short url creating a complete composite article for storage and analysis as the case may be.
