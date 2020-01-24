@isTest
private with sharing class AddNewExchangeRateShedullerTest {

    public static String CRON_EXP = '0 0 0 23 * ? 2022';

    static testmethod  void testScheduledJob() {

        Exchange_Rate__c exch = new Exchange_Rate__c(); 
        exch.Date__c =  Date.valueOf('2019-09-11');                         
        insert exch;

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ExchangeRatesStatic');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');      

       Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);
            // Schedule the test job
            String jobId = System.schedule('adding exchange',
                CRON_EXP, 
                new AddNewExchangeRateScheduler()); 
                AddNewExchangeRates.updateAddNewExchangeRates();       
        List<Exchange_Rate__c> result = [SELECT id, Date__c FROM Exchange_Rate__c]; 
        System.assertEquals(1, result.size()); 
        Test.stopTest();

        List<Exchange_Rate__c> result2 = [SELECT id, Date__c FROM Exchange_Rate__c]; 
        System.assertEquals(3, result2.size()); 

    }
    
}