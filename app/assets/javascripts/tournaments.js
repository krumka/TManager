$( document ).ready(function() {
    $("#addGame2Tournament").on("click", function (e) {
        e.preventDefault();
        $.redirectPost($('select#Games').val()+"/add", {game: $('select#Games').val()});
    });
    $("#delete_game").on("click", function (e) {
        e.preventDefault();
        $.redirectPost($(this).attr("href"), {game: 1});
    });
});



$.extend(
    {
        redirectPost: function(location, args)
        {
            var form = '';
            $.each( args, function( key, value ) {
                form += '<input type="hidden" name="'+key+'" value="'+value+'">';
            });
            $('<form action="'+location+'" method="POST">'+form+'</form>').appendTo('body').submit();
        },
        redirectDelete: function(location, args)
        {
            var form = '';
            $.each( args, function( key, value ) {
                form += '<input type="hidden" name="'+key+'" value="'+value+'">';
            });
            $('<form action="'+location+'" method="DELETE">'+form+'</form>').appendTo('body').submit();
        }
    }
);