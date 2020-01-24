global with sharing class AddNewExchangeRates {
    @future (callout=true)
    global static void updateAddNewExchangeRates() {

        String exchangeCurrency = ''; 
        String defaultBaseCurrency; 

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        ExchangeCurrencyHelper exchangeCurrencyHelper = new ExchangeCurrencyHelper();
        defaultBaseCurrency = exchangeCurrencyHelper.getDefaultBaseCurrency();
        exchangeCurrency = exchangeCurrencyHelper.getExchangeCurrency(defaultBaseCurrency);

        System.debug('exchangeCurrencyHelper.getExchangeCurrency = exchangeCurrency ' + exchangeCurrency);
        System.debug('baseCurrency ' + defaultBaseCurrency);

            Exchange_Rate__c ee = [SELECT Date__c FROM Exchange_Rate__c ORDER BY Date__c DESC LIMIT 1];
            String startDateLast = string.valueOf(ee.Date__c.AddDays (1));
            String endDateToday = string.valueOf(Date.today());
            System.debug('startDateLast ' + startDateLast + ' endDateToday  ' + endDateToday);
            request.setEndpoint('https://api.exchangeratesapi.io/history?start_at=' + startDateLast + '&end_at=' + endDateToday + '&symbols=' + exchangeCurrency + '&base='+ defaultBaseCurrency);

        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        List<Exchange_Rate__c> rates2 = new List<Exchange_Rate__c>();

        Log__c log = new Log__c();
        log.Response_Body__c = response.getBody().substring(0, 196);
        log.Status_Code__c = String.valueOf(response.getStatusCode());
        insert log;

        if (response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.                 
            Map<String, Object> rootMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody().replace('"date":', '"date_x":'));
            Map<String, Object> ratesMap = (Map<String, Object>) rootMap.get('rates');
            for (String date_x : ratesMap.keySet()) {
                
                Map<String, Object> rateMap = (Map<String, Object>) ratesMap.get(date_x);
                
                List<String> exchangeCurrencySplit = exchangeCurrency.split(',');

                String exchangeRateValues = '';
                List<Schema.SObjectType> objects = new List<Schema.SObjectType>{ Exchange_Rate__c.SObjectType};
                for(Schema.SObjectType objType: objects){
                         Exchange_Rate__c exch = new Exchange_Rate__c(); 
                         exch.Date__c =  Date.valueOf(date_x);                         
                         exch.Log__c = Log.Id;
                    for(Integer i= 0 ; i < exchangeCurrencySplit.size(); i++){
                        
                        for(Schema.SObjectField fld: objType.getDescribe().fields.getMap().values()){
                            
                            if(exchangeCurrencySplit[i] == fld.getDescribe().getLabel()){
                                System.debug('eeeeee' + exchangeCurrencySplit[i]); 
                                    
                                exch.put(fld.getDescribe().getName(), rateMap.get(exchangeCurrencySplit[i]));
                                System.debug('exch =  ' + exch);                                     
                            }                          
                        }                                                                                         
                    }
                    rates2.add(exch);
                }           
            }
            System.debug('rates2 =  ' + rates2);                       
        }
        insert rates2;         
    }

}
