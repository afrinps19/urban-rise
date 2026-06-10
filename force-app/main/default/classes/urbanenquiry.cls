public with sharing class urbanenquiry {

    @AuraEnabled(cacheable=true)
    public static List<Property__c> getProperties() {

        return [
            SELECT Id, Name
            FROM Property__c
            ORDER BY Name
        ];
    }

    @AuraEnabled
    public static Id createLead(
        String fullName,
        String phone,
        String email,
        Id propertyId
    ) {

        Lead__c leadRecord = new Lead__c();

        leadRecord.Name = fullName;
        leadRecord.Lead_Name__c = fullName;
        leadRecord.Phone__c = phone;
        leadRecord.Email__c = email;
        leadRecord.Status__c = 'New';

        leadRecord.property__c = propertyId;

        insert leadRecord;

        return leadRecord.Id;
    }
}