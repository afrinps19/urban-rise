@isTest
private class BookingDailySummarySchedulerTest {

    @isTest
    static void testDailySummaryScheduler() {

        List<Booking__c> bookings =
            new List<Booking__c>();

        bookings.add(
            new Booking__c(
                Name='B1',
                Status__c='Confirmed'
            )
        );

        bookings.add(
            new Booking__c(
                Name='B2',
                Status__c='Confirmed'
            )
        );

        bookings.add(
            new Booking__c(
                Name='B3',
                Status__c='Pending'
            )
        );

        bookings.add(
            new Booking__c(
                Name='B4',
                Status__c='Cancelled'
            )
        );

        insert bookings;

        Test.startTest();

        String cronExp =
            '0 0 8 * * ?';

        System.schedule(
            'Test Daily Summary',
            cronExp,
            new BookingDailySummaryScheduler()
        );

        Test.stopTest();

        List<CronTrigger> jobs =
            [
                SELECT Id
                FROM CronTrigger
            ];

        System.assert(
            jobs.size() > 0
        );
    }
}