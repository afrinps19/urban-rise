public with sharing class urbanRiseclass {

    @AuraEnabled(cacheable=true)
    public static List<Property__c> getProperties() {

        return [
            SELECT Id,
                   Property_Name__c,
                   Price_Per_Unit__c,
                   Location__c
            FROM Property__c
            LIMIT 6
        ];
    }
}