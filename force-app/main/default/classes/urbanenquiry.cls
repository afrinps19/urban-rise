public with sharing class urbanenquiry {

    @AuraEnabled
    public static Id createLead(
        String fullName,
        String phone,
        String email
    ){


        System.debug('******** APEX METHOD CALLED ********');
        System.debug('Full Name = ' + fullName);
        System.debug('Phone = ' + phone);
        System.debug('Email = ' + email);

        Lead__c leadRecord = new Lead__c();

        leadRecord.Name = fullName;
        leadRecord.Lead_Name__c = fullName;
        leadRecord.Phone__c = phone;
        leadRecord.Email__c = email;
        leadRecord.Status__c = 'New';

        insert leadRecord;

        System.debug('Lead Created: ' + leadRecord.Id);

        return leadRecord.Id;
    }
}