@isTest
public with sharing class UpdateExchangeRatesTest {
    
    //test return data moc
    @isTest static void testGetExchangeRatesController() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ExchangeRatesStatic');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        List<Exchange_Rate__c> result = ExchangeRateController.getExchangeRates('2019-09-10', '2019-09-11', 'GBP');
        System.assertNotEquals(null, result);
        System.assertEquals(2, result.size(), 'test data is not equals');
    }
    
    //test for status code = 150
    @isTest static  void testGetExchangeRatesControllerStatusCode() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ExchangeRatesStatic');
        mock.setStatusCode(150);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        List<Exchange_Rate__c> result = ExchangeRateController.getExchangeRates('2019-09-10', '2019-09-11', 'GBP');
        System.assertEquals(0, result.size());
    }
    
    //test insert in data base
    @isTest static  void testGetExchangeRatesEqualsDB() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ExchangeRatesStatic');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        Exchange_Rate__c exch = new Exchange_Rate__c(); 
        exch.Date__c =  Date.valueOf('2019-09-11');                         
        insert exch;
        
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        List<Exchange_Rate__c> result = ExchangeRateController.getExchangeRates('2019-09-10', '2019-09-11', 'GBP');
        Test.stopTest();
        System.assertEquals(2, result.size(), 'need exchange rate 2');
        List<Exchange_Rate__c> result2 = [SELECT id, Date__c FROM Exchange_Rate__c];
        
        System.assertEquals(result.size(), result2.size(), 'test exchange rate data in not DB');
    }
}