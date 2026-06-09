public with sharing class siteVisitController {

    @AuraEnabled
    public static Id createSiteVisit(
        Id propertyId,
        Date visitDate
    ) {

        User currentUser = [

            SELECT Id, Name, Email
            FROM User
            WHERE Id = :UserInfo.getUserId()
            LIMIT 1
        ];

        List<Buyer__c> buyers = [

            SELECT Id
            FROM Buyer__c
            WHERE Email__c = :currentUser.Email
            LIMIT 1
        ];

        if (buyers.isEmpty()) {

            throw new AuraHandledException(
                'Buyer record not found. Please contact administrator.'
            );
        }

        Buyer__c buyer = buyers[0];

        Site_Visit__c visit =
            new Site_Visit__c();

        visit.Name =
            'Visit - ' +
            currentUser.Name;

        visit.Buyer__c =
            buyer.Id;

        visit.property__c =
            propertyId;

        visit.Visit_Date__c =
            visitDate;

        visit.Status__c =
            'Scheduled';

        insert visit;

        System.debug(
            'Site Visit Created: ' +
            visit.Id
        );

        return visit.Id;
    }
}