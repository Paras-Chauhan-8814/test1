trigger DataLinkTrigger on Data_Link__c (before insert,before update,before delete) {

    //datalinkCallMapClass.method1(Trigger.new);

    if(Trigger.isInsert) {
        datalinkCall.dataLinkAccountUpdate(Trigger.new,'Insert');
    }
    if(Trigger.isUpdate) {
        datalinkCall.dataLinkAccountUpdate(Trigger.new, 'Update');
    }
    if(Trigger.isDelete) {
        datalinkCall.dataLinkAccountUpdate(Trigger.old, 'Delete');
    }
}