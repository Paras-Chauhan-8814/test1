public class Reconciliation_Apex_For_Delete_Records implements Schedulable {
   
    public void execute(SchedulableContext ctx) {

        Reconciliation_Batch_Class Obj = new Reconciliation_Batch_Class();
        Id batchJobId = Database.executeBatch(Obj);
    }
}

/*

// Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
Reconciliation_Apex_For_Delete_Records clsObj = new Reconciliation_Apex_For_Delete_Records();
String sch = '0 0 0 * * ?';
String jobID = System.schedule('Schedular for Batch Reconciliation Delete', sch, clsObj);

*/