public class accountCreateUsingPlatformEvents {
    
    public static void createUser(){


        // Account_Create_Event__e platformEventObject = new Account_Create_Event__e();
        // platformEventObject.User_Id__c = 'ghjkjh';

        // system.debug('Before');
        // EventBus.publish(platformEventObject);
        // system.debug('After');



        // List<PermissionSet> PermissionSetObject = [SELECT ID, Name FROM PermissionSet WHERE Label = 'Cloud Consultant Permission' LIMIT 1];
        // System.debug('PermissionSetObject >> '+PermissionSetObject);
        // Organization org = [SELECT id, Name FROM Organization];


        // User usr = new User();
        // usr.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Cloud Consultant Profile' limit 1].Id;                   
        // usr.LastName = 'Event3';
        // usr.Email = 'platform@event3.com';
        // usr.Username = 'platform@event3.com';
        // usr.CompanyName = 'Salesforce3';
        // usr.Title = 'Title';
        // usr.Alias = 'Event3';
        // usr.IsActive = true;
        // usr.TimeZoneSidKey = 'America/Los_Angeles';
        // usr.EmailEncodingKey = 'UTF-8';
        // usr.LanguageLocaleKey = 'en_US';
        // usr.LocaleSidKey = 'en_US';
        // insert usr;
        // System.debug('User >> '+usr);
    
    
        // PermissionSetAssignment PermissionSetAssignmentObj = new PermissionSetAssignment();
        
        // PermissionSetAssignmentObj.PermissionSetId = PermissionSetObject[0].ID;
        // PermissionSetAssignmentObj.AssigneeId = usr.ID;
        // insert PermissionSetAssignmentObj;
        // System.debug('PermissionSetAssignmentObj >> '+PermissionSetAssignmentObj);

        //Publish the platform User For a Sync Call
        Account_Create_Event__e platformEventObject = new Account_Create_Event__e();
        platformEventObject.User_Id__c = 'hsiids';
        // platformEventObject.User_Id__c = usr.ID;
        System.debug('platformEventObject >> '+platformEventObject);

        EventBus.publish(platformEventObject);


    }
}

//   accountCreateUsingPlatformEvents.createUser();




String userString = '{ "attributes": { "type": "User" },"isactive":"'+true+'","id":"'+userid+'","username":"test1234@gmail.com", "ProfileId":"'+profileRecord.Id+'","AccountId": "'+accountId+'", "ExternalId__c": "'+accountRecord.ExternalId__c+'", "ContactId":"'+contactId+'", "Account": { "attributes": { "type": "Account", "url": "/services/data/v49.0/sobjects/Account/'+accountId+'" },"EligibleToLogin__c":"'+true+'", "Id": "'+accountId+'", "Name": "Recruiter", "subsidiary__c": "DE", "ConsultantNumber__c": "9000000002", "ExternalId__c":"9000000002-DE-Consultant","ContactId__c":"'+contactId+'","ActivityStatusCode_p__c":"XA" }, "Contact": { "attributes": { "type": "Contact", "url": "/services/data/v49.0/sobjects/Contact/'+contactId+'" }, "Id": "'+contactId+'","ContactType__c":"Assistant", "firstname":"Test", "lastname":"Con", "subsidiary__c": "DE", "RecordTypeId":"'+consultantRecordTypeId+'", "ConsultantNumber__c": "9000000002", "ExternalId__c":"9000000002-DE-Consultant" } }';
User userRecord = (User) JSON.deserialize(userString, User.class);
userList.add(userRecord);

{"attributes":{"type":"Account","url":"/services/data/v50.0/sobjects/Account/0017Y00001EtmaOQAR"},"Name":"Test","X3P__c":"Active","JumiaDaraz_Country__c":"Uganda","RecordTypeId":"0123E000001Q9RZQA0","Vendor_main_email__c":"test@jumia.com","Id":"0017Y00001EtmaOQAR"}


accountObj.Name = 'Test';
        accountObj.X3P__c = 'Active';
        accountObj.JumiaDaraz_Country__c = 'Uganda';
        accountObj.RecordTypeId = accExcRecordTypeId;
        accountObj.Vendor_main_email__c = 'test@jumia.com';


Id accExcRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('JS EXC').getRecordTypeId();

String userString = '{"attributes":{"type":"Case","url":"/services/data/v50.0/sobjects/Case/'+caseObj.Id+'"},"RecordTypeId":"'+gsRecordTypeID+'","Subject":"testAPEX","Status":"New","Origin":"Phone","Type":"Jumia to EXC","JM_Country__c":"Maroc","AccountId":"'+accountObj.Id+'","Id":"'+caseObj.Id+'", "Account": {"attributes": { "type": "Account", "url": "/services/data/v50.0/sobjects/Account/'+accountObj.Id+'" },"Name": "Test","RecordTypeId":"'+accExcRecordTypeId+'","Vendor_main_email__c":"'+accountObj.Vendor_main_email__c+'","X3P__c":"Active","JumiaDaraz_Country__c":"Uganda","Id": "'+accountObj.Id+'"}}'

Case caseObj = (Case) JSON.deserialize(userString, Case.class);

"Account": { "attributes": { "type": "Account", "url": "/services/data/v50.0/sobjects/Account/'+accountObj.Id+'" },"RecordTypeId":"'+accExcRecordTypeId+'","Vendor_main_email__c":"'+accountObj.Vendor_main_email__c+'",,"X3P__c":"'+accountObj.Vendor_main_email__c+'","Id": "'+accountObj.Id+'","X3P__c":"Active","JumiaDaraz_Country__c":"Uganda"}