require_relative 'bundle/bundler/setup'
require 'json'
require 'httparty'

POST_URL = 'http://trendcrawl.herokuapp.com/api/v1/article'
GET_URL = 'http://trendcrawl.herokuapp.com/api/rubygem/bnext_robot/get_feeds'

cats = ['internet', 'tech', 'marketing', 'startup', 'people', 'skill']

cats.each do |cat|
  page_no = 1
  while page_no <= 20
    print "\rPosting aritcles of '#{cat}' at page #{page_no} "

    options = {
      headers: { 'Content-Type' => 'application/json' },
      query: { :cat => cat, :page_no => page_no }
    }

    # feeds = BNextRobot.new.get_feeds(cat, page_no).map(:to_hash).to_json
    # Each element in feeds is a Hash that contains all information of an article/feed
    get_result = HTTParty.get(GET_URL, options)
    feeds = JSON.parse(get_result.body)
    
    # Get response codes for every article/feed
    resps = feeds.map do |feed|
      options = {
        headers: { 'Content-Type' => 'application/json' },
        body: feed.to_json
      }
      result = HTTParty.post(POST_URL, options)
      result.code
    end

    # Termination criterion: posting a page where all articles/feeds have been posted before
    # 201: new posted
    # 208: already posted
    if resps.select { |resp| resp == 208 }.length == resps.length
      print "Posted!!"
      break
    end

    page_no += 1
  end
  print "\n"
end
