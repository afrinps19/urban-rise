public without sharing class UrbanRiseInvoiceController {

    public class InvoiceWrapper {

        @AuraEnabled public String invoiceNumber;
        @AuraEnabled public String buyerName;
        @AuraEnabled public String buyerEmail;
        @AuraEnabled public String buyerPhone;

        @AuraEnabled public String propertyName;
        @AuraEnabled public String location;

        @AuraEnabled public Decimal propertyPrice;
        @AuraEnabled public Decimal gstAmount;
        @AuraEnabled public Decimal discountAmount;
        @AuraEnabled public Decimal invoiceAmount;

        @AuraEnabled public Date dueDate;
        @AuraEnabled public String status;
    }

    @AuraEnabled(cacheable=true)
    public static InvoiceWrapper getInvoice() {

        String userEmail = [

            SELECT Email
            FROM User
            WHERE Id = :UserInfo.getUserId()

        ].Email;

        List<Invoice__c> invoices = [

            SELECT
                Invoice_Number__c,
                Invoice_Amount__c,
                Due_Date__c,
                Status__c,

                Booking__r.Status__c,

                Booking__r.Buyer__r.Name,
                Booking__r.Buyer__r.Email__c,
                Booking__r.Buyer__r.Phone__c,

                Booking__r.property__r.Property_Name__c,
                Booking__r.property__r.Location__c,
                Booking__r.property__r.Price_Per_Unit__c

            FROM Invoice__c

            WHERE
                Booking__r.Buyer__r.Email__c = :userEmail
                AND Booking__r.Status__c = 'Confirmed'

            ORDER BY CreatedDate DESC

            LIMIT 1
        ];

        if(invoices.isEmpty()){
            return null;
        }

        Invoice__c inv = invoices[0];

        Decimal price =
            inv.Booking__r.property__r.Price_Per_Unit__c;

        Decimal gst = price * 0.18;
        Decimal discount = price * 0.05;

        InvoiceWrapper wrap = new InvoiceWrapper();

        wrap.invoiceNumber =
            inv.Invoice_Number__c;

        wrap.buyerName =
            inv.Booking__r.Buyer__r.Name;

        wrap.buyerEmail =
            inv.Booking__r.Buyer__r.Email__c;

        wrap.buyerPhone =
            inv.Booking__r.Buyer__r.Phone__c;

        wrap.propertyName =
            inv.Booking__r.property__r.Property_Name__c;

        wrap.location =
            inv.Booking__r.property__r.Location__c;

        wrap.propertyPrice = price;
        wrap.gstAmount = gst;
        wrap.discountAmount = discount;

        wrap.invoiceAmount =
            price + gst - discount;

        wrap.dueDate =
            inv.Due_Date__c;

        wrap.status =
            inv.Status__c;

        return wrap;
    }
}