global class google_access_token_refresh_Schedule_cls implements Schedulable {
    global void execute(SchedulableContext SC) {
        google_access_token_refresh_batch_class obj = new google_access_token_refresh_batch_class();
        ID batchId = database.executebatch(obj); 
    }
}