#!/usr/bin/env coffee

## Config
#
access_token = 'Your weibo access token here'
#
# End
_ = require('underscore')
shelljs = require 'shelljs'
simplesets = require('simplesets')
weibo_mid = require('weibo-mid')



require('zappajs') ->
	@use 'partials'
	@enable 'default layout'
	@use 'bodyParser'

	purecss = 'http://cdn.staticfile.org/pure/0.3.0/pure-min'

	@get '/': ->
  	@render index: {title: '微博转发抽奖', stylesheet: purecss}

  @post '/result': ->
  	@render result: {title: '抽奖结果', stylesheet: purecss, winner: @win(@body)}

  @view index: ->
  	h1 @title
  	form action: '/result', enctype: 'application/x-www-form+xml', method: 'post', class: 'pure-form pure-form-stacked', ->
  		fieldset ->
  			input type: 'url', placeholder: '微博链接 e.g. http://weibo.com/user/Ab0', name: 'weibo_url', required: 'required', class: 'pure-input-2-3'
  			button type: 'submit', class: 'pure-button pure-button-primary', '手气不错'

  @view result: ->
  	h1 @title
  	p ->
  		a href: "http://weibo.com/#{@winner}", @winner


	@helper win: (form) ->


		# redirects < 200
		count = 200
		mid = _.last(form.weibo_url.split('/'))
		weibo_id = weibo_mid.decode(mid)

		repost_timeline = shelljs.exec("curl -s 'https://api.weibo.com/2/statuses/repost_timeline.json?count=#{count}&id=#{weibo_id}&access_token=#{access_token}'").output
		reposts = JSON.parse(repost_timeline).reposts
		users = (repost.user.id for repost in reposts)
		console.log(users)
		# 多次转发只计一次
		users = new simplesets.Set(users)
		users = users.array()

		# 使用blockchain的最新hash作种子，可重复验证
		latesthash = shelljs.exec("curl -s 'http://blockchain.info/q/latesthash'").output
		random_number = parseInt(latesthash, 16)
		user_index = random_number % users.length
		winner = users[user_index]