$( document ).ready(function() {
    if($("h1").text() == "Listing matches"){
        $(".btn-set-score").on("click", function (e) {
            e.preventDefault();
            delInputScore();
            var match_url = $(this).closest("tr").find(".btn-show").attr("href");
            var score_p1 = $(this).closest("tr").find(".score_p1");
            var score_p2 = $(this).closest("tr").find(".score_p2");
            score_p1.html("<input class='isp1' id='player1_score' type='number' value='" + score_p1.text() + "'>");
            score_p2.html("<input class='isp2' id='player2_score' type='number' value='" + score_p2.text() + "'>");
            score_p2.after("<a class='btn btn-success btn-send-scores'><i class=\"fa fa-check\" aria-hidden=\"true\"></i></a>");
            $(".btn-send-scores").on("click", function (e) {
                e.preventDefault();
                $.ajax({
                    type: "POST",
                    url: "/api/v1" + match_url + "/setScore",
                    data: { match: { player1_score: $("#player1_score").val(), player2_score: $("#player2_score").val() } },
                    dataType: "json",
                    success: function(done){
                        if(done.update){
                            score_p1.closest("td").html(done.html);
                        }
                    }
                });
            });
        })
    }
});
function delInputScore(){
    $(".isp1").closest("td").html("<span class=\"score_p1\">" + $(".isp1").val() + "</span> - <span class=\"score_p2\">" + $(".isp2").val() + "</span>")
}