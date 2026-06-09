public with sharing class PropertyController {

    @AuraEnabled(cacheable=true)
    public static List<Property__c> getProperties(){

        return [
            SELECT
                Id,
                Property_Name__c,
                Location__c,
                Status__c,
                Total_Units__c,
                Available_Units__c,
                Price_Per_Unit__c
            FROM Property__c
            ORDER BY CreatedDate DESC
        ];
    }
}