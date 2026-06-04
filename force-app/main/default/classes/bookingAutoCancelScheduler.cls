global class bookingAutoCancelScheduler
implements Schedulable {

    global void execute(
        SchedulableContext sc
    ) {

        Database.executeBatch(
            new BookingAutoCancelBatch(),
            200
        );
    }
}