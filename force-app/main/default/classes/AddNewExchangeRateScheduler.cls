global  class AddNewExchangeRateScheduler implements Schedulable {

    global void execute(SchedulableContext ctx) {

        AddNewExchangeRates.updateAddNewExchangeRates();
        
    } 
}