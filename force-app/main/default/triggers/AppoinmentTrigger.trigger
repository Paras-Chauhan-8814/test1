trigger AppoinmentTrigger on Appointment__c (before insert,before update) {
    
    if(Trigger.isInsert) {
        appointmentClassCall.appointmentConditions(Trigger.new, 'insert');
    }
    if(Trigger.isUpdate) {
        appointmentClassCall.appointmentConditions(Trigger.new, 'Update');
    }
    
}