require_relative 'bundle/bundler/setup'
require 'json'
require 'bnext_robot'
require 'httparty'

URL = 'http://trendcrawl.herokuapp.com/api/v1/article'

cats = ['internet', 'tech', 'marketing', 'startup', 'people', 'skill']

bot = BNextRobot.new

cats.map do |cat|
  (1..5).map do |pageno|
    print "\rPosting aritcles of '#{cat}' at page #{pageno}"
    feeds = bot.get_feeds(cat, pageno)
    feeds.each do |feed|
      h = Hash.new
      h['title'] = feed.title
      h['author'] = feed.author
      h['date'] = feed.date
      h['link'] = feed.link
      h['tags'] = feed.tags
      options = {
        body: h.to_json,
        headers: { 'Content-Type' => 'application/json' }
      }
      result = HTTParty.post(URL, options)
    end
  end
  print "\n"
end
