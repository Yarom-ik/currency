import { LightningElement, track, wire } from 'lwc';
import getExchangeRates from '@salesforce/apex/ExchangeRateController.getExchangeRates';
//import getExchangeFields from '@salesforce/apex/ExchangeRateController.getExchangeCurrency_c';

import BaseCurrency__c_FIELD from '@salesforce/schema/Exchange_Rate__c.BaseCurrency__c';
import Exchange_Rate_OBJECT from '@salesforce/schema/Exchange_Rate__c';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class ExchangeRate extends LightningElement {

  @track baseCurrency;
  @track exchangeRates;
  startDate;
  endDate;

  dateTyday;

  @track picklistValues;

  @track columns = [];

  @wire(getObjectInfo, { objectApiName: Exchange_Rate_OBJECT })
  objectInfo;

  @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: BaseCurrency__c_FIELD })
  BaseCurrencyPicklistValues({ error, data }) {
    if (data) {
      this.picklistValues = data.values;
      // eslint-disable-next-line no-console
      console.log('picklistValues== ' + this.picklistValues);

      let base = data.defaultValue;
      this.baseCurrency = base.value;
      // eslint-disable-next-line no-console
      console.log('baseCurrency ' + this.baseCurrency);
    } else if (error) {
      // eslint-disable-next-line no-console
      console.log(error);
    }
    this.dateTyday = new Date();
    let dd = String(this.dateTyday.getDate()).padStart(2, '0');
    let mm = String(this.dateTyday.getMonth() + 1).padStart(2, '0'); //January is 0!
    let yyyy = this.dateTyday.getFullYear();

    this.dateTyday = yyyy + '-' + mm + '-' + dd;

    // eslint-disable-next-line no-console
    console.log('dateTyday ' + this.dateTyday);
  }

  setStartDate(event) {
    this.startDate = event.target.value;
    // eslint-disable-next-line no-console
    console.log('strt Date = ' + this.startDate);
  }

  setEndDate(event) {
    this.endDate = event.target.value;
    // eslint-disable-next-line no-console
    console.log('end Date = ' + this.endDate);
  }

  handleChange(event) {
    this.baseCurrency = event.target.value;
    // eslint-disable-next-line no-console
    console.log('--.' + this.baseCurrency);
  }

  renderedExchangeRates() {
    if (this.baseCurrency === undefined) {
      return;
    }
    this.columns = [];

    const fields = {};
    fields.label = 'Date';
    fields.fieldName = 'Date__c';

    this.columns.push(fields);

    for (let i = 0; i < this.picklistValues.length; i++) {
      if (this.picklistValues[i].value !== this.baseCurrency) {
        this.columns.push({
          label: this.picklistValues[i].value,
          fieldName: this.picklistValues[i].value + '__c',
          type: 'number'
        });
      }
    }

    getExchangeRates({ startDate: this.startDate, endDate: this.endDate, baseCurrency: this.baseCurrency })
      .then(result => {
        this.exchangeRates = result;
        this.error = undefined;
      })
      .catch(error => {
        this.error = error;
        this.exchangeRates = undefined;
      });
  }

}