trigger leadTrigger on LEAD (before insert) {

    leadOwnerUpdate.changeLeadOwner(trigger.new);
}