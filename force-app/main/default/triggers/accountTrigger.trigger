trigger accountTrigger on Account (before update, after insert, after update) {

    if(Trigger.isUpdate && Trigger.isBefore) {

        accountUpdate.stopAccountUpdation(Trigger.new, Trigger.oldMap);

    }
    if(Trigger.isUpdate && Trigger.isAfter) {

        accountUpdate.deleteDefaultContact(Trigger.newMap, Trigger.oldMap);
    }

    if((Trigger.isInsert && Trigger.isAfter)) {

        accountUpdate.createDefaultContact(Trigger.newMap);
    }
}