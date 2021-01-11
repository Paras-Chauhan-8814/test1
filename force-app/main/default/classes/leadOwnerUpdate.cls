public class leadOwnerUpdate {
    
    public static void changeLeadOwner(List<Lead> triggerNewList) {
        
        System.debug('Calling >> ');
        string groupID = '';
        for(Lead leadObj : triggerNewList) {

            System.debug(leadObj.ownerID);
            groupID = leadObj.ownerID;
            //leadObj.ownerID = '0052w0000089W4HAAU';
        }

        List<GroupMember> groupMemberList = [Select UserOrGroupId From GroupMember where GroupId =:groupID];
        System.debug('UserID >> ' + groupMemberList);

    }
}
