({
    doinit : function(component, event, helper) {

        var googleCode = component.get("v.code");

        if(googleCode == "") {
            window.open('https://accounts.google.com/o/oauth2/v2/auth?scope=https://www.googleapis.com/auth/drive&access_type=offline&response_type=code&state=security_token%3D138r5719ru3e1%26url%3Dhttps%3A%2F%2Foauth2.example.com%2Ftoken&prompt=consent&redirect_uri=https://parascaorg1-developer-edition.ap16.force.com/apex/google_authorization_page&client_id=955089103435-1ql4480rsqqls4voauh1jq5dd0gn1oua.apps.googleusercontent.com');
            
        }
        else {

            var action = component.get("c.getAuthorizationCode"); 
            action.setParams({
                authorizationCode : googleCode
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('State Data Loaded>>'+state);
                if (state === "SUCCESS") {
                    console.log("Data Returns From >>",response.getReturnValue());
                } else {
                    alert("error");
                }
                });
                $A.enqueueAction(action);
        }

    },

    // handleClickHelper : function(component, event, helper) {

    //     window.open('https://accounts.google.com/o/oauth2/v2/auth?scope=email%20profile&response_type=code&state=security_token%3D138r5719ru3e1%26url%3Dhttps%3A%2F%2Foauth2.example.com%2Ftoken&redirect_uri=https://parascaorg1-developer-edition.ap16.force.com/apex/google_authorization_page&client_id=955089103435-1ql4480rsqqls4voauh1jq5dd0gn1oua.apps.googleusercontent.com');
    // }
})