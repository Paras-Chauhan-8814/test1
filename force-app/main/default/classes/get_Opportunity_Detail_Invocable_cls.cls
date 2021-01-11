public with sharing class get_Opportunity_Detail_Invocable_cls {
    @InvocableMethod(label = 'My Opportunity Detail')
    public static List<Opportunity>  getOpportunityInformation(List<String> nameInput) {

        List<Opportunity> oppList = [SELECT ID, CloseDate, StageName, Total_Product__c, ExpectedRevenue FROM Opportunity WHERE Name IN : nameInput];
        return oppList;
    }
}