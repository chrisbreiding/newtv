(function () {

	var Shows = {

		init : function () {
			this.events();
		},

		events : function () {
			$('#add-show').on('click', this.add);

			$(document.body)
				.on('click', '.file-name', this.selectText)

				.on('submit', '#show-search-form', this.search)
				.on('click', '.create-show', this.create)
				.on('click', '#close-results', this.closeResults)

				.on('click', '.edit-show', this.edit)
				.on('submit', '#edit-show-form', this.update)

				.on('click', '#delete-show', this.destroy)

				.on('click', '.show-all-episodes', this.all)

				.on('click', this.clear)
				.on('click', '#add-show, #show-search-form, #search-results, .edit-show, #edit-show-form, #all-episodes', this.stopClear);

		},

		selectText : function () {
			$(this).selectText();
		},

		add : function (e) {
			e.preventDefault();
			$(document.body).append( JST['templates/add_show'] );
		},

		search : function (e) {
			e.preventDefault();

			$('#show-search-form').addClass('waiting');
			$('#search-notice').html('searching&hellip;');

			$.ajax({
				url : '/shows/search.json',
				type : 'POST',
				dataType : 'json',
				data : $(this).serialize(),
				success : function (results) {

					var template = JST['templates/search_results'];

					if( !results.length ) {
						template = JST['templates/no_search_results'];
						$(template)
							.hide()
							.appendTo( $(document.body) )
							.slideDown();

						return;
					}

					$(template({ shows : results }))
						.hide()
						.appendTo( $(document.body) )
						.slideDown();

				},
				error : function (results) {
					App.notice({
						notice : 'An error occurred and the search failed. Please <a href="#" id="refresh-page">refresh the page</a> and try again.',
						type : 'error'
					});
				}
			});
		},

		closeResults : function (e) {
			e.preventDefault();

			$('#search-results').remove();
			$('#show-search-form').removeClass('waiting').find('input').select();
		},

		create : function (e) {
			e.preventDefault();

			var $this = $(this);

			$('#search-results').slideUp();
			$('#show-search-form').addClass('waiting');
			$('#search-notice').html('adding show and episodes&hellip;');

			$.ajax({
				url : '/shows.json',
				type : 'POST',
				dataType : 'json',
				data : {
					show : {
						name : $this.siblings('h4').text(),
						tvrage_id : $this.closest('.results-show').data('showid')
					}
				},
				success : function (results) {
					App.notice({
						notice : 'Show successfully added. Please <a href="#" id="refresh-page">refresh the page</a> to see upcoming episodes.',
						type : 'message'
					});

					Shows.clear();
				},
				error : function (results) {
					App.notice({
						notice : 'Show could not be added. Please close this message and try again.',
						type : 'error'
					});
				}
			});

		},

		edit : function (e) {
			e.preventDefault();

			$('#edit-show-form').remove();

			var $this = $(this),
				template = JST['templates/edit_show'],
				data = {
					name : $this.parent().siblings('.name').text(),
					id : $this.closest('.show').data('id')
				};

			$(template(data))
				.hide()
				.appendTo( $(document.body) )
				.center()
				.fadeIn('fast');
		},

		update : function (e) {
			e.preventDefault();

			var $this = $(this),
				id = $('#id').val();

			$.ajax({
				url : '/shows/' + id + '.json',
				type: 'PUT',
				dataType : 'json',
				data : $this.serialize(),
				success : function (results) {
					$('#show-' + id).find('.name').html( results.name );
					$('#edit-show-form').remove();
				}
			});
		},

		destroy : function (e) {
			e.preventDefault();

			var $form = $('#edit-show-form'),
				id = $('#id').val(),
				name = $('#show-' + id).find('.name').text();

			if( confirm('Are you sure you wish to delete ' + name + '?') ) {
				$.ajax({
					url : '/shows/' + id + '.json',
					type: 'DELETE',
					dataType : 'json',
					data : $form.serialize(),
					success : function (results) {
						$('#show-' + id).fadeOut(function (){
							$(this).remove();
						});
						$('#edit-show-form').remove();
						App.notice({
							notice : name + ' has been deleted.',
							type : 'message'
						});
					}
				});
			}
		},

		all : function (e) {
			e.preventDefault();

			$('.active').removeClass('active');
			$('#all-episodes').remove();

			var $this = $(this),
				template = JST['templates/all_episodes'],
				id = $this.closest('.show').data('id');

			$.ajax({
				url : '/shows/' + id + '.json',
				type: 'GET',
				dataType : 'json',
				success : function (results) {
					var data = {
						show : $('#show-' + id).addClass('active').find('.name').text(),
						seasons : results
					};

					$(template(data))
						.hide()
						.appendTo( $(document.body).addClass('showing-all') )
						.css({
							width : $(window).width() - 251,
							height : $(window).height() - 25
						})
						.slideDown();
				}
			});
		},

		clear : function () {
			$('#show-search-form').remove();
			$('#search-results').remove();
			$('#edit-show-form').remove();
			$('#all-episodes').remove();
			$(document.body).removeClass('showing-all');
		},

		stopClear : function (e) {
			e.stopPropagation();
		}

	};

	var App = {

		init : function () {
			this.noticeTemplate = JST['templates/notice'];
			this.$window = $(window);

			Shows.init();
			this.events();

			this.closeNoticeTimed();
		},

		events : function () {
			var self = this;

			$(document.body)
				.on('click', '#close-notice', this.closeNotice)
				.on('click', '#refresh-page', this.refresh);

			this.$window.resize(function() {
				self.resize();
			});
		},

		notice : function (config) {
			var self = this;
			$('#notice').remove();
			$(this.noticeTemplate(config))
				.hide()
				.prependTo($(document.body))
				.slideDown('fast', function () {
					self.closeNoticeTimed();
				});
		},

		closeNotice : function (e) {
			if(e) e.preventDefault();

			$('#notice').slideUp(function () {
				$(this).remove();
			});
		},

		closeNoticeTimed : function () {
			var self = this,
				$notice = $('#notice');
			if( $notice.length ) {
				setTimeout(function () {
					self.closeNotice.apply($notice);
				}, 4000);
			}
		},

		refresh : function (e) {
			e.preventDefault();
			window.location.reload(true);
		},

		resize : function () {
			$('#all-episodes').css({
				width : this.$window.width() - 251,
				height : this.$window.height() - 25
			});
		}

	};

	$(function() {

		App.init();

	});

}());
