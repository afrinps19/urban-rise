global class BookingDailySummaryScheduler
implements Schedulable {

    global void execute(SchedulableContext sc) {

        Integer totalBookings = 0;
        Integer confirmedBookings = 0;
        Integer cancelledBookings = 0;
        Integer pendingBookings = 0;

        // Aggregate Query
        List<AggregateResult> results = [
            SELECT Status__c status,
                   COUNT(Id) total
            FROM Booking__c
            GROUP BY Status__c
        ];

        for(AggregateResult ar : results){

            String status =
                (String)ar.get('status');

            Integer countValue =
                (Integer)ar.get('total');

            totalBookings += countValue;

            if(status == 'Confirmed'){
                confirmedBookings = countValue;
            }
            else if(status == 'Cancelled'){
                cancelledBookings = countValue;
            }
            else if(status == 'Pending'){
                pendingBookings = countValue;
            }
        }

        String emailBody =
            'Daily Booking Summary\n\n' +
            'Total Bookings : ' + totalBookings + '\n' +
            'Confirmed Bookings : ' + confirmedBookings + '\n' +
            'Cancelled Bookings : ' + cancelledBookings + '\n' +
            'Pending Bookings : ' + pendingBookings;

        Messaging.SingleEmailMessage mail =
            new Messaging.SingleEmailMessage();

        mail.setToAddresses(
            new String[]{
                UserInfo.getUserEmail()
            }
        );

        mail.setSubject(
            'Daily Booking Summary'
        );

        mail.setPlainTextBody(
            emailBody
        );

        Messaging.sendEmail(
            new Messaging.SingleEmailMessage[]{
                mail
            }
        );
    }
}