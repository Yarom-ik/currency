public class ExchangeRateController {    

    @AuraEnabled(cacheable = false)
    public static List<Exchange_Rate__c> getExchangeRates(String startDate, String endDate, String baseCurrency) {
    String defaultBaseCurrency;
    String exchangeCurrency = '';
        ExchangeCurrencyHelper exchangeCurrencyHelper = new ExchangeCurrencyHelper();
        exchangeCurrency = exchangeCurrencyHelper.getExchangeCurrencyWhich_c();

        System.debug('exchangeCurrency ' + exchangeCurrency);

        String query = 'SELECT Date__c, ' + exchangeCurrency + ' FROM Exchange_Rate__c ';
        System.debug('getExchangeRates ' + startDate + 'endDate'+ endDate + ' baseCurrency= ' + baseCurrency);
        if(startDate != null && endDate != null && baseCurrency != null){
            query += 'where Date__c >='+ startDate +' and Date__c <='+ endDate +
            ' and ' + baseCurrency + '__c = null ORDER BY Date__c ASC';
        } else {
            return null;
        }
        List<Exchange_Rate__c> listExchange = Database.query(query);

        System.debug('listExchange ' + listExchange);

        UpdateExchangeRates updateExchangeRates = new UpdateExchangeRates();
        List<Exchange_Rate__c> listExchangeFromAPI = updateExchangeRates.getExchangeRatesList(startDate, endDate, baseCurrency);
        System.debug('listExchangeFromAPI ' + listExchangeFromAPI);

        if(listExchange.size() == listExchangeFromAPI.size()){
              System.debug('listExchangeFromAPI == updateExchangeRates ---> true' );  
        } else {
            List<Exchange_Rate__c> listExchangeFromAPItoBD = new List<Exchange_Rate__c>();

            List<Date> listDate = new List<Date>();
            for(Exchange_Rate__c ex : listExchange){
                listDate.add(ex.Date__c);
            }

                for(Exchange_Rate__c ex : listExchangeFromAPI){
                    if(!listDate.contains(ex.Date__c)){
                         System.debug('NoT equals date ' ); 
                         listExchangeFromAPItoBD.add(ex);
                    }
                }
            
            System.debug('listExchangeFromAPItoBD ' + listExchangeFromAPItoBD); 
            System.debug('listExchangeFromAPI ' + listExchangeFromAPI); 
            insert listExchangeFromAPItoBD;

            listExchangeFromAPI.sort();
            System.debug('listExchangeFromAPI SORTED ' + listExchangeFromAPI);

            return listExchangeFromAPI;
        }
        //listExchange.sort();
        return listExchange;
    }
}