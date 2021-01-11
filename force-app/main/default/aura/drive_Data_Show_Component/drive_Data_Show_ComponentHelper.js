({
    handleClickHelper : function(component, event, helper) {

        //alert('Calling');

        var action = component.get("c.getGoogleData"); 
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('State Data Loaded>>'+state);
                if (state === "SUCCESS") {
                    console.log("Data Returns From getGoogleData>>",response.getReturnValue());
                    var conts = response.getReturnValue();
                    var custs = [];
                    for ( var key in conts ) {
                        console.log('key'+conts[key]);
                        console.log('key'+key);
                        custs.push({value:conts[key], key:"https://drive.google.com/open?id="+key});
                    }
                    component.set('v.mapdata',custs);
                } else {
                    alert("error");
                }
                });
                $A.enqueueAction(action);
        },

        navigateToRecordHelper : function(component, event, helper) {


            alert('id');
            var name = event.getSource().get("v.label");
            console.log('id >>'+name);
        },
        getFolderNameHelper : function(component, event, helper) {
            console.log('input text >> ' +component.get("v.inputtext"));
            var action = component.get("c.createFolder"); 
            action.setParams({
                name : component.get("v.inputtext")
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('State Data Loaded>>'+state);
                if (state === "SUCCESS") {
                    console.log("Data Returns From getGoogleData>>",response.getReturnValue());
                } else {
                    alert("error");
                }
                });
                $A.enqueueAction(action);
        },
})