public class Reconciliation_Queueable_for_user implements Queueable{

    private List<User> userList;
    public Reconciliation_Queueable_for_user(List<User> userList) {

        this.userList = userList;
    }

    public Void execute(System.QueueableContext qc) {
        System.debug('Que Class Called >>');
        try{

            for(User u : userList) {
                u.isActive = False;
            }
            if(userList.size() > 0) {
                
                Database.Update(userList, False);   
                System.debug('userList>>'+userList);
            }
        }
        Catch (Exception exp) {
                system.debug('The following exception has occurred in Class "Reconciliation_Queueable_for_user" : ' + exp.getMessage() +
                        ' at Line no: ' + exp.getLineNumber());
        }  
        
    }
}
