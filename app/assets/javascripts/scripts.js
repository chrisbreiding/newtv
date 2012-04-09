_.templateSettings = {
	interpolate: /\{\{\=(.+?)\}\}/g,
	evaluate: /\{\{(.+?)\}\}/g
};

jQuery(function($){

	var Shows = {
	
		init : function () {
			this.events();
		},
		
		events : function () {
			$('.file-name').on('click', this.selectText);
			
			$('#add-show').on('click', this.add);
			$(document.body).on('submit', '#show-search-form', this.search);
			$(document.body).on('click', '.create-show', this.create);
			$(document.body).on('click', '#close-results', this.closeResults);
			
			$(document.body).on('click', this.clear);
			$(document.body).on('click', '#show-search-form, #search-results', this.stopClear);			
		},
		
		selectText : function () {
			$(this).selectText();
		},
		
		add : function (e) {
			e.preventDefault();
			e.stopPropagation();
			
			var template = $('#add-show-template').html();
			
			$(document.body).append( _.template(template) );
		},
		
		search : function (e) {
			e.preventDefault();
			
			$('#show-search-form').addClass('waiting');
			
			$.ajax({
				url : '/shows/search.json',
				type : 'POST',
				dataType : 'json',
				data : $(this).serialize(),
				success : function (results) {
					
					var template = $('#search-results-template').html();
					
					if( !results.length ) {
						template = $('#no-search-results-template').html();
						$(template)
							.hide()
							.appendTo( $(document.body) )
							.slideDown();
						
						return;
					}
										
					$( _.template( template, { shows : results } ) )
						.hide()
						.appendTo( $(document.body) )
						.slideDown();
					
				},
				error : function (results) {
					App.notice({
						notice : 'An error occurred and the search failed. Please <a href="#" class="refresh-page">refresh the page</a> and try again.',
						type : 'error'
					});
					
					console && console.log(results);
				}
			});
		},
		
		create : function (e) {
			e.preventDefault();
			
			var $this = $(this);
			
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
						notice : 'Show successfully added. Please <a href="#" class="refresh-page">refresh the page</a> to see upcoming episodes.',
						type : 'message'
					});
					
					Shows.clear();
				},
				error : function (results) {
					App.notice({
						notice : 'Show could not be added. Please close this message and try again.',
						type : 'error'
					});
					
					console && console.log(results);
				}
			});

		},
		
		clear : function () {
			$('#show-search-form').remove();
			$('#search-results').remove();
		},
		
		stopClear : function (e) {
			e.stopPropagation();
		},
		
		closeResults : function (e) {
			e.preventDefault();
			
			$('#search-results').remove();
			$('#show-search-form').removeClass('waiting').find('input').select();
		}
		
	};
	
	var App = {
	
		init : function () {
			this.noticeTemplate = $('#notice-template').html();
		
			Shows.init();
			this.events();
		},
		
		events : function () {
			$(document.body).on('click', '.close-notice', this.closeNotice);
			$(document.body).on('click', '.refresh-page', this.refresh);
		},
		
		notice : function (config) {
					
			$( _.template( this.noticeTemplate, config) )
				.hide()
				.appendTo($(document.body))
				.slideDown();
					
		},
		
		closeNotice : function (e) {
			e.preventDefault();
			
			$('.notice').slideUp(function () {
				$(this).remove();
			});
		},
		
		refresh : function (e) {
			e.preventDefault();
			window.location.reload(true);
		}
						
	};

	App.init();

});