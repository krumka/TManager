$( document ).ready(function() {
    $("#addGame2Tournament").on("click", function (e) {
        e.preventDefault();
        console.log("test");
        $.redirectPost($('select#Games').val()+"/add", {game: $('select#Games').val()});
    })
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
        }
    }
);