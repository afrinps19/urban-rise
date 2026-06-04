@isTest
private class bookingAutoCancelBatchTest {

    @isTest
    static void testBatchExecution() {

        Property__c property = new Property__c(
            Name = 'Test Property',
            Available_Units__c = 5
        );

        insert property;

        Booking__c booking = new Booking__c(
            Status__c = 'Pending',
            Booking_Dates__c = Date.today().addDays(-10),
            Property__c = property.Id
        );

        insert booking;

        Test.startTest();

        Database.executeBatch(
            new BookingAutoCancelBatch(),
            200
        );

        Test.stopTest();

        Booking__c updatedBooking =
            [
                SELECT Status__c
                FROM Booking__c
                WHERE Id = :booking.Id
            ];

        Property__c updatedProperty =
            [
                SELECT Available_Units__c
                FROM Property__c
                WHERE Id = :property.Id
            ];

        System.assertEquals(
            'Cancelled',
            updatedBooking.Status__c
        );

        System.assertEquals(
            6,
            updatedProperty.Available_Units__c
        );
    }

    @isTest
    static void testScheduler() {

        Test.startTest();

        System.schedule(
            'Test Scheduler',
            '0 0 0 * * ?',
            new BookingAutoCancelScheduler()
        );

        Test.stopTest();

        CronTrigger ct =
            [
                SELECT Id
                FROM CronTrigger
                LIMIT 1
            ];

        System.assertNotEquals(
            null,
            ct.Id
        );
    }
}