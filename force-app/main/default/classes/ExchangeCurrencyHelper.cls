public with sharing class ExchangeCurrencyHelper {

    Schema.DescribeFieldResult F = Exchange_Rate__c.BaseCurrency__c.getDescribe();
    List <Schema.PicklistEntry> pickVals = F.getPicklistValues();  

    String exchangeCurrency = '';  
    String defaultBaseCurrency; 

    //get default base currency
    public String getDefaultBaseCurrency() {       
        for (Schema.PicklistEntry pv: pickVals) {
            if (pv.isDefaultValue ()) {
            defaultBaseCurrency = pv.getValue();
            } 
        }
        return defaultBaseCurrency;
    }

    //get defaults exchange currency
    public String getExchangeCurrency(String baseCurrency) {  
        if(baseCurrency == null){  
            for (Schema.PicklistEntry pv: pickVals) {
                if (!pv.isDefaultValue ()) {                
                    exchangeCurrency += pv.value + ',';
                }    
            }
           exchangeCurrency = exchangeCurrency.removeEnd(',');
        }else {
            //baseCurrency = baseCurrency.substring(0, 3);
            System.debug(' bc -->' + baseCurrency);
            for (Schema.PicklistEntry pv: pickVals) {
                if (pv.value != baseCurrency) {                
                    exchangeCurrency += pv.value + ',';
                }    
            }
            exchangeCurrency = exchangeCurrency.removeEnd(',');
        }
        return exchangeCurrency;
    }

    //get defaults exchange currency whith __c
    public String getExchangeCurrencyWhich_c() {    
            for (Schema.PicklistEntry pv: pickVals) {
                if (!pv.isDefaultValue ()) {                
                    exchangeCurrency += pv.value + '__c,';
                }    
            }
           exchangeCurrency = exchangeCurrency.removeEnd(',');
        return exchangeCurrency;
    }

}