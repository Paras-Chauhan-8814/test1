public class ReconcilationLwc_1_Class1 {
    
    @AuraEnabled
    public static void reconciliationCreateMethod(String firstName, String lastName, String phone, String email, String status, String source){


        List<PermissionSet> PermissionSetObject = [SELECT ID, Name FROM PermissionSet WHERE Label = 'Cloud Consultant Permission' LIMIT 1];
        System.debug('PermissionSetObject >> '+PermissionSetObject);
        Organization org = [SELECT id, Name FROM Organization];
        System.debug('org >> '+org);


        User usr = new User();
        usr.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Cloud Consultant Profile' limit 1].Id;                   
        usr.LastName = lastName;
        usr.Email = email;
        usr.Username = email + org.ID;
        usr.CompanyName = 'Salesforce';
        usr.Title = 'Title';
        usr.Alias = lastName;
        usr.IsActive = true;
        usr.TimeZoneSidKey = 'America/Los_Angeles';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.LocaleSidKey = 'en_US';
        insert usr;
        System.debug('user new >>'+usr);

        PermissionSetAssignment PermissionSetAssignmentObj = new PermissionSetAssignment();
        
        PermissionSetAssignmentObj.PermissionSetId = PermissionSetObject[0].ID;
        PermissionSetAssignmentObj.AssigneeId = usr.ID;
        insert PermissionSetAssignmentObj; 
        
        user ua = [SELECT ID, isActive FROM User WHERE Name = 'Jack La'];
        System.resetPassword(ua.ID, true);

        // String uid = '0052w000008Dv0EAAS'; //Custom User ID test User
        String uid = '0052w0000089W4HAAU'; //Custom User ID Akshu Chauhan User ID

        // String uid = usr.ID; //Custom User ID Akshu Chauhan User ID

        // String userName =  'paras.chauhan@caorg1.com';
        // String userName =  usr.Username;
        String userName =  'ksupurple@zwwaltered.com00d2w00000fabmaear';
        String emailTemplateName = 'User_Reset_Password_Email';
        // String emailTemplateName = 'Sending_Email_For_User_Reset_Password';

        //resetPasswordForUser(userName, emailTemplateName);
        
        // myFutureMethodForCreateRecords(firstName,lastName,phone,email,status,source,uid);
        
    }

    public static void resetPasswordForUser(String userName, String emailTemplateName) {

        site.forgotPassword(userName, emailTemplateName);
        System.debug('Send Email >>>');
    }


    @future
    public static void myFutureMethodForCreateRecords(String firstName, String lastName, String phone, String email, String status, String source, String uid)
    {   
         
        System.debug('First Name in Future Method >> ');

        Id devRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Assisstant').getRecordTypeId();

        Account accountObject = new Account();
        accountObject.Name = firstName;
        accountObject.Email__c = email;
        accountObject.OwnerID = uid;
        insert accountObject;

        Contact contactObject = new Contact();
        contactObject.FirstName = firstName;
        contactObject.LastName = lastName;
        contactObject.Email = email;
        contactObject.AccountId = accountObject.ID;
        contactObject.OwnerID = uid;
        contactObject.RecordTypeID = devRecordTypeId;
        insert contactObject;

        Reconciliation__c obj = new Reconciliation__c();
        obj.Name = firstName+' '+lastName;
        obj.First_Name__c = firstName;
        obj.Last_Name__c = lastName;
        obj.Email__c = email;
        obj.Source_P__c = source;
        obj.Status_p__c = status;
        obj.Phone__c = phone;
        obj.Account_lr__c = accountObject.ID;
        obj.OwnerID = uid;
        insert obj;

        System.debug('Account Record >>' + accountObject);
        System.debug('Contact Record >>' + contactObject);
        System.debug('Reconciliation Record >>' + obj);
    }
}


// for (User u : users) {
            // System.resetPassword(uid, true);
        // }
        // site.forgotPassword('paras.chauhan@caorg1.com', 'Sending_Email_For_User_Reset_Password');
        // site.forgotPassword('salesuserteam@gmail.com', 'Sending Email For User Reset Password');
        // site.forgotPassword('paras.chauhan@caorg1.com');
        // site.forgotPassword('paras.chauhan@caorg1.com', 'Sending Email For User Reset Password');
        // String uid = usr.ID;
        // resetPasswordForUser(usr.Username, 'Sending Email For User Reset Password');
        //resetPasswordForUser('paras.chauhan@caorg1.com', 'Sending Email For User Reset Password');