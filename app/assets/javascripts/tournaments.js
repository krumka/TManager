$( document ).ready(function() {
    $("#addGame2Tournament").on("click", function (e) {
        e.preventDefault();
        game_id = $('select#Games').val();
        $.ajax({
            type: "POST",
            url: "/api/v1/tournaments/addGame2Tournament",
            data: { game_id: game_id, tournament_id: $('#tournament_id').text() },
            dataType: "json",
            success: function(done){
                $("#gamesOnTournament").append(done.html);
                addEventDelete($(".btn-delete-game").last());
                $('option[value="' + game_id + '"]').remove();
            }
        });
    });
    addEventDelete($(".btn-delete-game"));
    $("#generate_matches").on("click", function (e) {
        e.preventDefault();
        var tournament_id = $(location).attr('href').split("/");
        tournament_id = tournament_id[tournament_id.length-1];
        tournament_id = tournament_id.split("?")[0];
        $.ajax({
            type: "POST",
            url: "/api/v1/tournaments/generate_matches",
            data: { tournament_id: tournament_id },
            dataType: "json",
            success: function(done){
                if(done.generate){
                    $(".last").before(done.html);
                    $('html,body').animate({scrollTop: $("#matches").offset().top},'slow');
                }
            },
            error: function (e) {
                console.log(e.responseText);
            }
        });
    });
});

function addEventDelete(elem){
    elem.on("click", function (e) {
        e.preventDefault();
        line = $(this).parent().parent();
        game_id = $(this).attr("href");
        game_name = $(this).closest(".game_name a").text();
        tournament_id = $('#tournament_id').text();
        $.ajax({
            type: "POST",
            url: "/api/v1/tournaments/deleteGame2Tournament",
            data: { game_id: game_id, tournament_id: tournament_id },
            dataType: "json",
            success: function(done){
                if(done.delete){
                    line.remove();
                    $("select").append(done.html)
                }
            }
        });
    });
}