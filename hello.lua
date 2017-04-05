local tweet = ARGV[1]
local key_tweet = KEYS[1]
local key_keywords = KEYS[2]
local key_total_tweets_count = KEYS[3]
local key_scores = KEYS[4]
local key_main_feed = KEYS[5]

redis.call("SET", key_tweet, tweet) -- Save the tweet
redis.call("INCR", key_total_tweets_count) -- Increase the total tweet count
redis.call("LPUSH", key_main_feed, tweet) -- Push the tweet to the main feed
redis.call("LTRIM", key_main_feed, 0, 100) -- Trim the main feed

local keywords = redis.call("SMEMBERS", key_keywords)  -- Get the keywords

for i, name in ipairs(keywords) do
    if string.find(tweet, name) then
        local substream_name = "sub_feed:" .. name
        redis.call("LPUSH", substream_name, tweet) -- Push the tweet to the sub feed
        redis.call("LTRIM", substream_name, 0, 100) -- Trim the sub feed
        redis.call("ZINCRBY", key_scores, 1, name) -- Increment the score for the keyword in the leaderboard
    end
end

return "OK"