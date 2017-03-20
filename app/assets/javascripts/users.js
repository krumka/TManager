$( document ).ready(function() {
    var urllast = $(location).attr('href').split("/");
    urllast = urllast[urllast.length-1];
    urllast = urllast.split("?")[0];
    if (urllast == 'sign_up' || urllast == 'users'){
        console.log("validating...");
        $("#new_user").validate({
            rules: {
                "user[username]": {
                    required: true,
                    minlength: 4
                },
                "user[email]": {
                    required: true,
                    email: true
                },
                "user[password]": {
                    required: true,
                    minlength: 8
                },
                "user[password_confirmation]": {
                    required: true,
                    equalTo: "#user_password"
                }
            },
            submitHandler: function (form) {
                $.ajax({
                    type: "POST",
                    url: "/api/v1/email/exists",
                    data: { email: $("#user_email").val() },
                    dataType: "json",
                    success: function(data){
                        if(data.email){
                            $("#user_email").after("<label id=\"user_email-error\" class=\"error\" for=\"user_email\">Email already exists</label>");
                        }else{
                            $.ajax({
                                type: "POST",
                                url: "/api/v1/username/exists",
                                data: { username: $("#user_username").val() },
                                dataType: "json",
                                success: function(data){
                                    console.log(data);
                                    if(data.username){
                                        $("#user_username").after("<label id=\"user_username-error\" class=\"error\" for=\"user_username\">Username already exists</label>");
                                    }else{
                                        //$("#new_user").submit();
                                        console.log('valid form submitted');
                                    }
                                }
                            });
                        }
                    }
                });
                return false; // for demo
            }
        });
        console.log("...ok");
    }
});