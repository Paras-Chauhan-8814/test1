public with sharing class get_order_total_price_invoc {

    public class quantityOrderId {

        @InvocableVariable(required=true)
        public ID orderID;
        @InvocableVariable(required=true)
        public String quantity;
        @InvocableVariable(required=true)
        public String email;
        // @InvocableVariable(required=true)
        // public String address;
    }

    @InvocableMethod(label = 'Get order total Price')
    public static List<foodorder__c>  getTotalPrice(List<quantityOrderId> nameInput) {

        System.debug('nameInput >> '+nameInput);
        System.debug('orderID >> '+nameInput[0].orderID);
        System.debug('order Quantity >> '+nameInput[0].quantity);
        List<String> foodDetail = new List<String>();
        foodorder__c foodList = new foodorder__c();

        User u = [SELECT ID FROM USER WHERE Name = 'Paras Chauhan'];
        //System.debug(u);
        try{

            foodList = [SELECT Name, SElectedFood__c, Quantity__c, totalPrice__c, Price__c, Address__c, Email__c FROM foodorder__c WHERE ID =: nameInput[0].orderID];
    
            integer totalPrice = integer.ValueOF(nameInput[0].quantity) * integer.ValueOF(foodList.Price__c);
            foodList.totalPrice__c = totalPrice;
            foodList.OwnerId = u.ID;
            foodList.Quantity__c = integer.ValueOF(nameInput[0].quantity);
            foodList.Email__c = nameInput[0].email;
            // foodList.Email__c = 'paras.chauhan@cloudanalogy.com';
            // foodList.Address__c = nameInput[0].address;
            System.debug('foodList Updated>> '+foodList);
            UPDATE foodList;
        }

        Catch (Exception exp) {
            system.debug('The following exception has occurred in method "getTotalPrice" : ' + exp.getMessage() +
                         ' at Line no: ' + exp.getLineNumber());
        }
        // foodorder__c foodList2 = [SELECT Name, SElectedFood__c, Quantity__c, totalPrice__c, Address__c,Email__c FROM foodorder__c WHERE ID =: foodList.ID];
        // System.Debug('foodList2>> '+foodList2);
        return new List<FoodOrder__c> {foodList} ;
    }
}