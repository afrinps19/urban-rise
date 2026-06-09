public with sharing class propertiesController {

    @AuraEnabled(cacheable=true)
    public static List<Property__c> getProperties(){

        return [

            SELECT
                Id,
                Property_Name__c,
                Location__c,
                Available_Units__c,
                Total_Units__c,
                Price_Per_Unit__c,
                Status__c,
                Property_Image__c

            FROM Property__c

            WHERE Status__c = 'Available'

            ORDER BY Property_Name__c
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Property__c> searchProperties(
        String searchText
    ){

        String searchPattern =
            '%' + searchText + '%';

        return [

            SELECT
                Id,
                Property_Name__c,
                Location__c,
                Available_Units__c,
                Total_Units__c,
                Price_Per_Unit__c,
                Status__c,
                Property_Image__c

            FROM Property__c

            WHERE
                Property_Name__c LIKE :searchPattern
                OR
                Location__c LIKE :searchPattern

            ORDER BY Property_Name__c
        ];
    }

}