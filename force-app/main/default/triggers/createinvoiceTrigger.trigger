trigger createinvoiceTrigger on Booking__c (after update) {

    if (Trigger.isAfter && Trigger.isUpdate) {
        createinvoiceHandler.createInvoices(
            Trigger.new,
            Trigger.oldMap
        );
    }
}