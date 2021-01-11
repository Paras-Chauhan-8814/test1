({
    getAccountData: function (component, event, helper) {
        var actions = [
          { label: "Edit", name: "Edit" },
          { label: "Delete", name: "Delete" }
        ];
    
        component.set("v.columns", [
          { label: "Account Name", fieldName: "Name", type: "text" },
          { label: "Revanue", fieldName: "AnnualRevenue", type: "text" },
          { label: "Account Number", fieldName: "AccountNumber", type: "text" },
          { label: "Phone", fieldName: "Phone", type: "Phone" },
          {
            label: "Action",
            type: "action",
            typeAttributes: { rowActions: actions, menuAlignment: "right" }
          }
        ]);
    
        var action = component.get("c.callRestApiClass");
        action.setCallback(this, function (response) {
          var state = response.getState();
          console.log('State Data Loaded>>'+state);
          if (state === "SUCCESS") {
            component.set("v.data", response.getReturnValue());
            console.log("Succesfully Display Data");
          } else {
            alert("error");
          }
        });
        $A.enqueueAction(action);
      },

      Updateacchelper : function(component, event, helper) {

        let id = component.get('v.accFormEdit.Id');
        var action = component.get("c.updateAccount");
        console.log();
        action.setParams({
            name : component.get("v.accFormEdit.Name"), 
            phone : component.get("v.accFormEdit.Phone"),
            aid : id,
            accountNumber : component.get("v.accFormEdit.AccountNumber"),
            annualRevenue : component.get( "v.accFormEdit.AnnualRevenue")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
              console.log("Succesfully Returned Values>>"+response.getReturnValue());
              var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Account Updated Successfully',
                        type: 'success',
                    });
                    toastEvent.fire();
              
            } else {
              var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message: 'Account Not Updated Successfully',
                        type: 'error',
                    });
                    toastEvent.fire();
            }
          });
          $A.enqueueAction(action);
      },

      deleteAccount : function(component, event, helper) {

        let id = component.get('v.accFormEdit.Id');
        var action = component.get("c.deleteAccount");
        action.setParams({
          aid : id
        });
        action.setCallback(this, function (response) {
          var state = response.getState();
          if (state === "SUCCESS") {
            console.log("Succesfully Returned Values>>"+response.getReturnValue());
            var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Account Deleted Successfully',
                        type: 'success',
                    });
                    toastEvent.fire();
            
          } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: 'Account Not Deleted Successfully',
                type: 'error',
            });
            toastEvent.fire();
        }
          
        });
        $A.enqueueAction(action);
        this.getAccountData(component, event, helper);
      }
})