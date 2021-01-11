public with sharing class get_select_fod_price_invoc {

    @InvocableMethod(label = 'Get Selected Food Price')
    public static List<String>  getFoodPriceInformation(List<String> nameInput) {

        User u = [SELECT ID FROM USER WHERE Name = 'Paras Chauhan'];
        List<String> foodDetail = new List<String>();
        List<String> strList = nameInput[0].split('\\ ');
        foodorder__c obj = new foodOrder__c();
        obj.SElectedFood__c = strList[0];
        obj.OwnerId = u.ID;
        obj.Price__c = decimal.ValueOf(strList[2]);

        insert obj;
        //System.debug(strList[2]);

        return new List<String> {obj.ID} ;
    }
}