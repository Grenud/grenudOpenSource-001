import { LightningElement } from 'lwc';
import  getStateDistrictPicklist from '@salesforce/apex/StateDistrictPicklist.getStateDistrictPicklist';
export default class TestComponent extends LightningElement {

 stateVSdistrict = { 
        "Uttar Pradesh" : [{value: 'Aligarh', label: 'Aligarh'}, {value: 'Bulandsahar', label: 'Bulandsahar'} ],
        "Madhya Pradesh" : [{value: 'Raisen', label: 'Raisen'}, {value: 'Bhopal', label: 'Bhopal'}]
    }

 DistrictValues = [
        { value: 'Aligarh', label: 'Aligarh', description: 'A new item' },
        {
            value: 'Raisen',
            label: 'Raisen'
            
        }
    ];

    value = 'new';


userInput ;
filertoption;
     handleInvoiceBlur = (event)=> {
     
     this.userInput = event.target.value;
     
        console.log(this.userInput);

        //this.filertoption = stateVSdistrict["Uttar Pradesh"];
        //this.filertoption = this.stateVSdistrict['"' + this.userInput + '"'];
         this.filertoption = this.stateVSdistrict[this.userInput ];
        console.log(this.filertoption);   
    }
  
}