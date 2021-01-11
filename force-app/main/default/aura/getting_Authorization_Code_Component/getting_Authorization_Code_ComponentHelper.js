({
    doinit : function(component, event, helper) {

        console.log('component.get  '+component.get("v.code"));
        var codd = component.get("v.code");
        if(codd != "") {
        
            var action = component.get("c.getAccessToken");
            action.setParams({
                authorizationCode : codd
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('State Data Loaded>>'+state);
                if (state === "SUCCESS") {
                  console.log("Data",response.getReturnValue());
                } else {
                  alert("error");
                }
              });
              $A.enqueueAction(action);
        }
    },
    createIssueshelper : function(component, event, helper) {

            var action = component.get("c.createIssueInJira");
            
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                  console.log(" Create Issues Returned >> ",response.getReturnValue());
                } else {
                  alert("error");
                }
              });
              $A.enqueueAction(action);
        },

        UpdateIssueshelper : function(component, event, helper) {
            var action = component.get("c.updateIssueInJira");
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                  console.log(" Updated Issues Returned >> ",response.getReturnValue());
                } else {
                  alert("error");
                }
              });
              $A.enqueueAction(action);
        },

        deletehelper : function(component, event, helper) {
            var action = component.get("c.deleteIssueInJira");
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                  console.log(" Updated Issues Returned >> ",response.getReturnValue());
                } else {
                  alert("error");
                }
              });
              $A.enqueueAction(action);
        },

        Refreshhelper : function(component, event, helper) {

          //alert('Refresh');
            var action = component.get("c.refreshAccessToken");
            
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                  console.log(" Refreshed  Access Token >> ", response.getReturnValue());
                } else {
                  alert("error");
                }
              });
              $A.enqueueAction(action);
        },


})