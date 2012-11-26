//= require_tree .

class ThxGive

	images: []
	currentIndex: 0

	constructor: ->
		@fetchImages 'https://api.instagram.com/v1/tags/thxgive/media/recent?access_token=26458622.f59def8.d3bd01d99d9647bb825a6c10adad9537&callback=?'
		@setEventListeners()

	setEventListeners: ->
		$('.photo img').live 'click', @openPhoto
		$('.dim').live 'click', @closeOverlay
		$(window).on 'keyup', @navigatePhotos
		$('.arr').live 'click', @navigatePhotos

	fetchImages: (url) ->
		$.getJSON url, @parseResults

	parseResults: (data) =>
		@images = $.merge @images, data.data
		@showResults data.data

		if data.pagination.next_url
			@fetchImages data.pagination.next_url+"&callback=?"


	showResults: (images) ->
		for item, i in images
			html = "<div class='photo' data-id='#{item.id}' id='photo-#{item.id}'>"
			html += "<img src='#{item.images.low_resolution.url}' />"
			html += "<div class='user'><img src='#{item.user.profile_picture}' /> <a href='http://instagram.com/#{item.user.username}'>#{item.user.username}</a></div>"

			if item.likes
				html += "<div class='likes'> <span>&hearts;</span> #{item.likes.count} </div>"
			html += "</div>"

			$('#loader').fadeOut 200
			$("body").append html
			TweenLite.to $("#photo-#{item.id}"), .3,
				css:
					opacity: 1
				delay: i*.1


	openPhoto: (e) =>
		for item, i in @images
			if item.id == $(e.target).parent().data 'id'

				@currentIndex = i

				$('.overlay').show()
				$('.content').html "<div class='user'><img src='#{item.user.profile_picture}' /> <a href='http://instagram.com/#{item.user.username}'>#{item.user.username}</a></div><img src='#{item.images.standard_resolution.url}' /><p>#{item.caption.text}</p>"

				TweenLite.to $('.dim'), .2,
					css:
						opacity: 1

				TweenLite.to $('.content'), .2,
					css:
						scale: 1
					delay: .2

				$('.arr').delay(300).fadeIn(200)

	closeOverlay: ->
		$('.arr').fadeOut 200

		TweenLite.to $('.dim'), .2,
			css:
				opacity: 0

		TweenLite.to $('.content'), .2,
			css:
				scale: 0
			onComplete: ->
				$('.overlay').hide()

	navigatePhotos: (e) =>
		lastIndex = @currentIndex
		if e.keyCode is 39 or $(e.currentTarget).hasClass 'next'
			unless @currentIndex == @images.length - 1
				@currentIndex++

		else if e.keyCode is 37 or $(e.currentTarget).hasClass 'prev'
			unless @currentIndex == 0
				@currentIndex--

		unless lastIndex == @currentIndex
			item = @images[@currentIndex]
			$('.content *').fadeOut 200, ->
				$('.content').html "<div class='user'><img src='#{item.user.profile_picture}' /> <a href='http://instagram.com/#{item.user.username}'>#{item.user.username}</a></div><img src='#{item.images.standard_resolution.url}' /><p>#{item.caption.text}</p>"
				$('.content *').hide().fadeIn 200



thx = new ThxGive