public with sharing class adminDashboardController {

    public class DashboardData {

        @AuraEnabled public Integer totalProperties;
        @AuraEnabled public Integer totalEnquiries;
        @AuraEnabled public Integer totalUnits;
        @AuraEnabled public Integer availableUnits;
        @AuraEnabled public Decimal totalRevenue;
        @AuraEnabled public Integer pendingInvoices;
        @AuraEnabled public Integer totalSiteVisits;
        @AuraEnabled public Integer openLeads;

        @AuraEnabled public List<Lead__c> leads;
        @AuraEnabled public List<Site_Visit__c> siteVisits;
        @AuraEnabled public List<Property__c> properties;
    }

    @AuraEnabled(cacheable=true)
    public static DashboardData getDashboardData() {

        DashboardData data = new DashboardData();

        /* =======================
           TOTAL COUNTS
        ======================= */

        data.totalProperties =
            [SELECT COUNT() FROM Property__c];

        data.totalEnquiries =
            [SELECT COUNT() FROM Lead__c];

        data.openLeads =
            [SELECT COUNT()
             FROM Lead__c
             WHERE Status__c != 'Qualified'
             AND Status__c != 'Converted'];

        data.pendingInvoices =
            [SELECT COUNT()
             FROM Invoice__c
             WHERE Status__c = 'Pending'];

        data.totalSiteVisits =
            [SELECT COUNT() FROM Site_Visit__c];

        /* =======================
           UNITS (SAFE)
        ======================= */

        Integer totalUnits = 0;
        Integer availableUnits = 0;

        for (Property__c p : [
            SELECT Total_Units__c, Available_Units__c, Price_Per_Unit__c
            FROM Property__c
        ]) {

            totalUnits += (p.Total_Units__c == null ? 0 : Integer.valueOf(p.Total_Units__c));
            availableUnits += (p.Available_Units__c == null ? 0 : Integer.valueOf(p.Available_Units__c));
        }

        data.totalUnits = totalUnits;
        data.availableUnits = availableUnits;

        /* =======================
           REVENUE CALCULATION
        ======================= */

        Decimal revenue = 0;

        for (Property__c p : [
            SELECT Total_Units__c, Available_Units__c, Price_Per_Unit__c
            FROM Property__c
        ]) {

            Integer total = (p.Total_Units__c == null ? 0 : Integer.valueOf(p.Total_Units__c));
            Integer available = (p.Available_Units__c == null ? 0 : Integer.valueOf(p.Available_Units__c));

            Integer sold = total - available;

            if (p.Price_Per_Unit__c != null) {
                revenue += sold * p.Price_Per_Unit__c;
            }
        }

        data.totalRevenue = revenue;

        /* =======================
           RECENT LEADS
        ======================= */

        data.leads = [
            SELECT Id, Name, Email__c, Phone__c, Status__c, CreatedDate
            FROM Lead__c
            ORDER BY CreatedDate DESC
            LIMIT 5
        ];

        /* =======================
           SITE VISITS
        ======================= */

        data.siteVisits = [
            SELECT Id, Name, Visit_Date__c, Status__c,
                   Buyer__r.Name,
                   Property__r.Property_Name__c
            FROM Site_Visit__c
            ORDER BY Visit_Date__c ASC
            LIMIT 5
        ];

        /* =======================
           PROPERTIES
        ======================= */

        data.properties = [
            SELECT Id, Property_Name__c, Location__c,
                   Total_Units__c, Available_Units__c, Status__c
            FROM Property__c
            LIMIT 6
        ];

        System.debug('Dashboard JSON => ' + JSON.serialize(data));

        return data;
    }
}