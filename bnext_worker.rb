require_relative 'bundle/bundler/setup'
require 'json'
require 'httparty'

POST_URL = 'https://bnext-dynamo.herokuapp.com/api/v1/article/'
GET_URL = 'https://trendcrawl.herokuapp.com/api/v1/article/filter/'
DEL_URL = 'https://trendcrawl.herokuapp.com/api/v1/article/'

option = { headers: { 'Content-Type' => 'application/json' } }
result = HTTParty.get(GET_URL, option)

feeds = JSON.parse(result.body)

feeds = feeds[0...100] if feeds.length >= 100

feeds.each do |feed|
  feed.delete 'created_at' if feed.has_key? 'created_at'
  feed.delete 'updated_at' if feed.has_key? 'updated_at'
end

feeds.each do |feed|
  id = feed.delete 'id'

  option = {
    headers: { 'Content-Type' => 'application/json' },
    body: feed.to_json
  }

  resp = HTTParty.post(POST_URL, option)
  puts "Posting [#{id}] #{feed['title']}"
  puts "Status: #{resp.code}"

  if resp.code == 201 or resp.code == 208
    resp = HTTParty.delete(DEL_URL + "#{id}/")
    puts "Delete [#{id}]"
    puts "Status: #{resp.code}"
  end

  puts ""

  sleep(5)
end
