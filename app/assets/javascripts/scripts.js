(function () {

  $body = $(document.body);

  var Shows = {

    init : function () {
      this.events();
    },

    events : function () {
      $('#add-show').on('click', this.add);

      $body
        .on('click', '.file-name', this.selectText)

        .on('submit', '#show-search-form', this.search)
        .on('click', '.create-show', this.create)
        .on('click', '#close-results', this.closeResults)

        .on('click', '.edit-show', this.edit)
        .on('submit', '#edit-show-form', this.update)

        .on('click', '#delete-show', this.destroy)

        .on('click', '.show-all-episodes', this.all)
        .on('click', '#shadowbox', this.clear)

        .on('click', this.clear)
        .on('click', '#add-show, #show-search-form, #search-results, .edit-show, #edit-show-form, #all-episodes', this.stopClear);

    },

    selectText : function () {
      $(this).selectText();
    },

    add : function (e) {
      e.preventDefault();
      $(JST['templates/add_show']())
        .appendTo( $body.addClass('shadowboxed') )
        .fadeIn('fast');
      $('#show-search-name').focus();
    },

    search : function (e) {
      e.preventDefault();

      $('#search-results-wrap, #no-search-results').hide();
      $searchNotice = $('#search-notice');
      $searchNotice.show().find('h3').text('searching...');

      $.ajax({
        url : '/shows/search.json',
        type : 'POST',
        dataType : 'json',
        data : $(this).serialize(),
        success : function (results) {
          $searchNotice.hide();

          if( results.length ) {

            $('#no-search-results').hide();
            $( JST['templates/search_results']({ shows: results }) )
              .appendTo( $('#search-results') )
              .slideDown();
            $('#search-results-wrap').slideDown();

          } else {

            $('#search-results-wrap').hide();
            $('#no-search-results').show();

          }
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

      $('#search-results-wrap').slideUp('fast');
      $('#search-notice').show().find('h3').text('adding show and episodes...');

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
          name : $this.closest('.show').data('name'),
          id : $this.closest('.show').data('id')
        };

      $(template(data))
        .appendTo( $body.addClass('shadowboxed') )
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
          $('.show-' + id).data('name', results.name).find('.name').html( results.name );
          App.removeShadowbox();
        }
      });
    },

    destroy : function (e) {
      e.preventDefault();

      var $form = $('#edit-show-form'),
        id = $('#id').val(),
        name = $('.show-' + id).data('name');

      if( confirm('Are you sure you wish to delete ' + name + '?') ) {
        $.ajax({
          url : '/shows/' + id + '.json',
          type: 'DELETE',
          dataType : 'json',
          data : $form.serialize(),
          success : function (results) {
            $('.show-' + id).remove();
            App.removeShadowbox();
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
            show : $('.show-' + id).data('name'),
            seasons : results
          };

          $(template(data))
            .appendTo( $body.addClass('shadowboxed') )
            .fadeIn('fast');
        }
      });
    },

    clear : function () {
      App.removeShadowbox();
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
      $body
        .on('click', '#close-notice', this.closeNotice)
        .on('click', '#refresh-page', this.refresh);
    },

    notice : function (config) {
      var self = this;
      $('#notice').remove();
      $(this.noticeTemplate(config))
        .hide()
        .prependTo($body)
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

    removeShadowbox : function () {
      $('#shadowbox').remove();
      $body.removeClass('shadowboxed');
    }

  };

  $(function() {

    App.init();

  });

}());
