public with sharing class contactController {

    @AuraEnabled
    public static Id createLead(
        String fullName,
        String email,
        String phone
    ) {
        System.debug('=== createLead CALLED ===');
        System.debug('Name: ' + fullName);
        System.debug('Email: ' + email);
        System.debug('Phone: ' + phone);

        Lead__c leadRecord = new Lead__c();

        leadRecord.Name = fullName;
        leadRecord.Lead_Name__c = fullName;
        leadRecord.Email__c = email;
        leadRecord.Phone__c = phone;
        leadRecord.Status__c = 'New';

        insert leadRecord;

        System.debug('Lead Created: ' + leadRecord.Id);

        return leadRecord.Id;
    }
}