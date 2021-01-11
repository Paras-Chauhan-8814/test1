({
    sendhelper : function(component, event, helper) {

        //alert('calling');
        var body1 = component.get('v.messageBody');
        var from1 = component.get('v.from');
        var to1 = component.get('v.to');

        console.log(body1);
        console.log(from1);
        console.log(to1);
        var action = component.get("c.twillioSendSms");
        console.log(action);
        action.setParams({
            body : body1,
            fromNumber : from1,
            toNumber : to1
        });
console.log('enter');
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('stste>>'+ state);
            console.log('State Data Loaded>>'+state);
            if (state === "SUCCESS") {
                // console.log("Data Returns From getGoogleData>>",response.getReturnValue());
                component.set('v.messageBody',"");
                component.set('v.from',"");
                component.set('v.to',"");
            } else {
                alert("error");
            }
            });
            $A.enqueueAction(action);
    },
})