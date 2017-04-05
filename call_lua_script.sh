#!/usr/bin/env bash

redis-cli --eval hello.lua tweet_123 keywords total_tweets_count scores main_feed , "A tweet about the words foo and bar"