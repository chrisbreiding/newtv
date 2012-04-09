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
					
					$( _.template( template, { shows : results } ) )
						.appendTo( $(document.body) )
						.slideDown();
					
				},
				error : function (results) {
					console.log(results);
				}
			});
		},
		
		create : function (e) {
			e.preventDefault();

console.log('create show with id ' + $(this).closest('.results-show').data('showid') );
		},
		
		clear : function () {
			
			$('#show-search-form').remove();
			$('#search-results').remove();
			
		},
		
		stopClear : function (e) {
		
			e.stopPropagation();
			
		}
			
	};
	
/*
	var App = {
	
		init : function () {
			
			Shows.init();
			
			this.events();
			
		},
		
		events : function () {
		
		
		}
			
	};

	App.init();
*/
	
	Shows.init();
			

});