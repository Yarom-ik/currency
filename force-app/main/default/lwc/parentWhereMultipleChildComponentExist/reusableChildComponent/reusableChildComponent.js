import { LightningElement, api } from 'lwc';

export default class ReusableChildComponent extends LightningElement {
    @api inputLabel;
  
  @api checkValidity() {
    var inputCmp = this.template.querySelector(".inputCmp");
    var value = inputCmp.value;
    // is input is valid?
    if (!value) {
      inputCmp.setCustomValidity("Please Enter a valid Value");
    } else {
      inputCmp.setCustomValidity(""); // if there was a custom error before, reset it
    }
    inputCmp.reportValidity(); // Tells lightning-input to show the error right away without needing interaction
  }
}