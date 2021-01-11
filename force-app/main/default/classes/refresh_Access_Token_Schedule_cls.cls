global class refresh_Access_Token_Schedule_cls implements Schedulable {
    global void execute(SchedulableContext SC) {
        refresh_Access_Token_batch_cls M = new refresh_Access_Token_batch_cls();
        database.executebatch(M); 
    }
}