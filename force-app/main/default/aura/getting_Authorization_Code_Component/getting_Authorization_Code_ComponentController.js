({
    init : function(component, event, helper) {

        helper.doinit(component, event, helper);
    },
    createIssues : function(component, event, helper) {

        helper.createIssueshelper(component, event, helper);
    },
    UpdateIssues : function(component, event, helper) {

        helper.UpdateIssueshelper(component, event, helper);
    },
    delete : function(component, event, helper) {

        helper.deletehelper(component, event, helper);
    },
    Refresh : function(component, event, helper) {

        helper.Refreshhelper(component, event, helper);
    },

    handleClick : function(component, event, helper) {

        window.open('https://auth.atlassian.com/authorize?audience=api.atlassian.com&client_id=hxKsJUvD6f1v77l2wjGeB8H3BwiBM72a&scope=offline_access%20read%3Ajira-work%20manage%3Ajira-project%20manage%3Ajira-configuration%20read%3Ajira-user%20write%3Ajira-work%20manage%3Ajira-data-provider&redirect_uri=https%3A%2F%2Fparascaorg1-developer-edition.ap16.force.com%2Fapex%2Fgetting_auth_code_pages&state=${YOUR_USER_BOUND_VALUE}&response_type=code&prompt=consent');
   
    
    }
})