global class bookingAutoCancelBatch implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {

        return Database.getQueryLocator(
            [
                SELECT Id,
                       Status__c,
                       Booking_Dates__c,
                       Property__c
                FROM Booking__c
                WHERE Status__c = 'Pending'
                AND Booking_Dates__c <= :Date.today().addDays(-7)
            ]
        );
    }

    global void execute(
        Database.BatchableContext bc,
        List<Booking__c> scope
    ) {

        List<Booking__c> bookingsToUpdate = new List<Booking__c>();

        Set<Id> propertyIds = new Set<Id>();

        for(Booking__c booking : scope){

            booking.Status__c = 'Cancelled';
            bookingsToUpdate.add(booking);

            if(booking.Property__c != null){
                propertyIds.add(booking.Property__c);
            }
        }

        Map<Id, Property__c> propertyMap =
            new Map<Id, Property__c>(
                [
                    SELECT Id,
                           Available_Units__c
                    FROM Property__c
                    WHERE Id IN :propertyIds
                ]
            );

        for(Booking__c booking : scope){

            if(propertyMap.containsKey(booking.Property__c)){

                Property__c prop =
                    propertyMap.get(booking.Property__c);

                prop.Available_Units__c =
                    (prop.Available_Units__c == null ? 0 :
                     prop.Available_Units__c) + 1;
            }
        }

        Database.SaveResult[] bookingResults =
            Database.update(bookingsToUpdate,false);

        Database.SaveResult[] propertyResults =
            Database.update(propertyMap.values(),false);

        for(Database.SaveResult sr : bookingResults){

            if(!sr.isSuccess()){

                for(Database.Error err : sr.getErrors()){

                    System.debug(
                        'Booking Error : ' + err.getMessage()
                    );
                }
            }
        }

        for(Database.SaveResult sr : propertyResults){

            if(!sr.isSuccess()){

                for(Database.Error err : sr.getErrors()){

                    System.debug(
                        'Property Error : ' + err.getMessage()
                    );
                }
            }
        }
    }

    global void finish(Database.BatchableContext bc){

        System.debug(
            'Booking Auto Cancellation Batch Completed'
        );
    }
}