public with sharing class get_Food_with_price_invocable {
    @InvocableMethod(label = 'Get Food With Price')
    public static List<List<String>>  getFoodInformation(List<String> nameInput) {

        List<String> foodDetail = new List<String>();
        List<Food__c> foodList = [SELECT Name, Price__c, Catagory__c FROM Food__c WHERE Catagory__c IN : nameInput];
        for(Food__c f : foodList) {
            String food = f.Name+' RS- '+f.Price__c;
            // String food = '';
            // food.name = f.Name;
            // food.price = f.Price__c;
            foodDetail.add(food);
        }
        return new List<List<String>> {foodDetail} ;
    }
}