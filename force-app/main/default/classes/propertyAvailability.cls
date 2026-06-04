public with sharing class propertyAvailability {

    @AuraEnabled(cacheable=true)
    public static List<PropertyWrapper> getPropertyAvailability() {

        List<PropertyWrapper> results = new List<PropertyWrapper>();

        List<Property__c> properties = [
            SELECT Id,
                   Name,
                   Total_Units__c,
                   Available_Units__c
            FROM Property__c
            ORDER BY Name
        ];

        for(Property__c prop : properties){

            Integer totalUnits =
                prop.Total_Units__c == null
                ? 0
                : Integer.valueOf(prop.Total_Units__c);

            Integer availableUnits =
                prop.Available_Units__c == null
                ? 0
                : Integer.valueOf(prop.Available_Units__c);

            Integer soldUnits =
                totalUnits - availableUnits;

            Decimal soldPercentage =
                totalUnits > 0
                ? ((Decimal)soldUnits / totalUnits) * 100
                : 0;

            PropertyWrapper pw = new PropertyWrapper();

            pw.id = prop.Id;
            pw.name = prop.Name;
            pw.total = totalUnits;
            pw.available = availableUnits;
            pw.sold = soldUnits;
            pw.soldPercent = soldPercentage.setScale(0);

            if(availableUnits == 0){
                pw.status = 'SOLD OUT';
                pw.cardClass = 'property-card sold';
                pw.badgeClass = 'badge sold-badge';
                pw.progressClass = 'progress-fill sold-progress';
            }
            else if(
                ((Decimal)availableUnits / totalUnits) * 100 < 30
            ){
                pw.status = 'LOW';
                pw.cardClass = 'property-card low';
                pw.badgeClass = 'badge low-badge';
                pw.progressClass = 'progress-fill low-progress';
            }
            else{
                pw.status = 'AVAILABLE';
                pw.cardClass = 'property-card available';
                pw.badgeClass = 'badge available-badge';
                pw.progressClass = 'progress-fill available-progress';
            }

            pw.progressStyle =
                'width:' + String.valueOf(pw.soldPercent) + '%';

            results.add(pw);
        }

        return results;
    }

    public class PropertyWrapper {

        @AuraEnabled public Id id;
        @AuraEnabled public String name;
        @AuraEnabled public Integer total;
        @AuraEnabled public Integer available;
        @AuraEnabled public Integer sold;
        @AuraEnabled public Decimal soldPercent;

        @AuraEnabled public String status;
        @AuraEnabled public String cardClass;
        @AuraEnabled public String badgeClass;
        @AuraEnabled public String progressClass;
        @AuraEnabled public String progressStyle;
    }
}