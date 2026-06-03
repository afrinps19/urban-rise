public class CreateInvoiceHandler {

    public static void createInvoices(
        List<Booking__c> newBookings,
        Map<Id, Booking__c> oldMap
    ) {

        Set<Id> propertyIds = new Set<Id>();

        for (Booking__c booking : newBookings) {

            if (
                booking.Status__c == 'Confirmed' &&
                oldMap.get(booking.Id).Status__c != 'Confirmed' &&
                booking.property__c != null
            ) {
                propertyIds.add(booking.property__c);
            }
        }

        if (propertyIds.isEmpty()) {
            return;
        }

        Map<Id, property__c> propertyMap =
            new Map<Id, property__c>(
                [
                    SELECT Id,
                           Price_Per_Unit__c
                    FROM property__c
                    WHERE Id IN :propertyIds
                ]
            );

        List<Invoice__c> invoicesToInsert = new List<Invoice__c>();

        for (Booking__c booking : newBookings) {

            if (
                booking.Status__c == 'Confirmed' &&
                oldMap.get(booking.Id).Status__c != 'Confirmed'
            ) {

                property__c prop =
                    propertyMap.get(booking.property__c);

                if (prop != null) {

                    Invoice__c inv = new Invoice__c();

                    inv.Name = 'INV-' + booking.Name;
                    inv.Booking__c = booking.Id;
                    inv.Invoice_Amount__c = prop.Price_Per_Unit__c;
                    inv.Due_Date__c = booking.Booking_Dates__c.addDays(7);
                    inv.Status__c = 'Pending';

                    invoicesToInsert.add(inv);
                }
            }
        }

        if (!invoicesToInsert.isEmpty()) {
            insert invoicesToInsert;
        }
    }
}