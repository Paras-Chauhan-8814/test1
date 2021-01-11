({
        init: function (component, event, helper) {
            helper.getAccountData(component, event, helper);
          },
          
          closeModel : function(component,event,helper){

            component.set( "v.isModalEdit", false);
          },
          handleRowActions : function(component,event,helper){
            var name = event.getParam('action');
            var act = name.name;
            var row = event.getParam('row');

            if(act == 'Edit' ) {
                component.set( "v.isModalEdit", true);
                component.set("v.accFormEdit", row);
            }
            if(act == 'Delete' ) {
                component.set("v.accFormEdit", row);
                if(confirm('Are you sure you want to delete?')){

                  helper.deleteAccount(component,event,helper);
                }
                
            }
          },

          Updateacc : function(component,event,helper) {

            helper.Updateacchelper(component,event,helper);
            helper.getAccountData(component, event, helper);
            component.set( "v.isModalEdit", false);
          }
      })