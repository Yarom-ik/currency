import { LightningElement, api} from 'lwc';

import option1 from './stepOne/stepOne.html';
import option2 from './reusableChildComponent/reusableChildComponent.html';

export default class ParentWhereMultipleChildComponentExist extends LightningElement {
    handleClick() {
        this.template
          .querySelectorAll("c-reusable-child-component")
          .forEach(element => {
            element.checkValidity();
          });
      }
      @api whichone = 'first';
 
      swapTemplate() {
        this.whichone = this.whichone === 'first' ? 'second' : 'first';
      }
     
      render() {
        return this.whichone === 'first' ? option1 : option2;
      }
     
}