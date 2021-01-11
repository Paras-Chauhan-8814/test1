trigger contactTrigger on Contact (before Update, before insert) {

    if(Trigger.isUpdate) {
        
        contactUpdate.contactAccountApproved(Trigger.new);
    }
    if(Trigger.isInsert || Trigger.isUpdate) {
        
        multiContactChack.chackAccountAllowMultiple(Trigger.new);
    }
}