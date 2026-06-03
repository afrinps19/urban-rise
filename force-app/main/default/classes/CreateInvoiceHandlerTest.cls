@IsTest
public class CreateInvoiceHandlerTest {

    @IsTest
    static void testInvoiceCreation() {

        property__c prop = new property__c(
            Name = 'Apartment A',
            Property_Name__c = 'Apartment A',
            Price_Per_Unit__c = 500000
        );
        insert prop;

        Buyer__c buyer = new Buyer__c(
            Name = 'Test Buyer'
        );
        insert buyer;

        Booking__c booking = new Booking__c(
            Name = 'Booking 1',
            property__c = prop.Id,
            Buyer__c = buyer.Id,
            Booking_Dates__c = Date.today(),
            Booking_Amount__c = 10000,
            Status__c = 'Pending'
        );
        insert booking;

        Test.startTest();

        booking.Status__c = 'Confirmed';
        update booking;

        Test.stopTest();

        List<Invoice__c> invoices = [
            SELECT Id,
                   Invoice_Amount__c,
                   Due_Date__c,
                   Status__c
            FROM Invoice__c
        ];

        System.assertEquals(1, invoices.size());
        System.assertEquals(500000, invoices[0].Invoice_Amount__c);
        System.assertEquals(Date.today().addDays(7), invoices[0].Due_Date__c);
        System.assertEquals('Pending', invoices[0].Status__c);
    }

    @IsTest
    static void testBulkInvoiceCreation() {

        property__c prop = new property__c(
            Name = 'Bulk Property',
            Property_Name__c = 'Bulk Property',
            Price_Per_Unit__c = 100000
        );
        insert prop;

        Buyer__c buyer = new Buyer__c(
            Name = 'Bulk Buyer'
        );
        insert buyer;

        List<Booking__c> bookings = new List<Booking__c>();

        for(Integer i = 0; i < 200; i++) {

            bookings.add(
                new Booking__c(
                    Name = 'Booking ' + i,
                    property__c = prop.Id,
                    Buyer__c = buyer.Id,
                    Booking_Dates__c = Date.today(),
                    Booking_Amount__c = 5000,
                    Status__c = 'Pending'
                )
            );
        }

        insert bookings;

        for(Booking__c booking : bookings) {
            booking.Status__c = 'Confirmed';
        }

        Test.startTest();
        update bookings;
        Test.stopTest();

        Integer invoiceCount = [
            SELECT COUNT()
            FROM Invoice__c
        ];

        System.assertEquals(200, invoiceCount);
    }
}