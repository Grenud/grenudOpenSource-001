import { LightningElement, track, wire, api } from 'lwc';
import Logo from '@salesforce/resourceUrl/FortuneLogo';
import ADDICON from '@salesforce/resourceUrl/AddIcon';
import DELETEICON from '@salesforce/resourceUrl/DeleteIcon';
import SALE_INVOICE_OBJECT from '@salesforce/schema/Sale_Invoice__c';
import Product_Item_OBJECT from '@salesforce/schema/Product_Item__c';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import DISTRICT_FIELD from '@salesforce/schema/Sale_Invoice__c.District__c';
import STATE_FIELD from '@salesforce/schema/Sale_Invoice__c.State__c';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getRecord } from 'lightning/uiRecordApi';
import  getStateDistrictPicklist from '@salesforce/apex/StateDistrictPicklist.getStateDistrictPicklist';
const FIELDS = ['Sale_Invoice__c.Party__r.Name', 'Product_Item__c.Product2.Name'];


export default class CreateSale extends LightningElement {
  //Test Comment 12
  FortuneLogoUrl = Logo;
  addIcon=ADDICON;
  DeleteIcon=DELETEICON;
  @track productName;
  @track quantity;
  @track unitPrice;
  @track description;
  @track lineItems = [];
  @api recordId;
  @track selectedAccount;
  Unitrate ;
 Quantity;
 Discount;
 Totalprice;
 Discountprice;
  @track rows = [
    {index: 0, SrNo:1, item: '', description: '',  quantity: '', UoM: '',  rate: '', Discount: '',DiscountPrice: '', Total: ''   }
];
  selectedState = '';
  selectedDistrict = '';
  StateOptions = [];
  DistrictOptions = [];
  isDistrictDisabled = true;

  @wire(getStateDistrictPicklist)
  StateDistrictMapping({data, error}) {
      if(data) {
          this.StateOptions = data.map(item => {
              return {label: item.State__c, value: item.State__c};
          });
      } else if(error) {
          console.error('Error retrieving State and District values:', error);
      }
  }

  handleStateChange(event) {
      this.selectedState = event.detail.value;
      this.selectedDistrict = '';
      this.isDistrictDisabled = true;
      if(this.selectedState) {
        const stateDistrictData = this.StateDistrictMapping.data;
        const districtData = stateDistrictData.find(item => item.State__c === this.selectedState);
        if (districtData) {
         // this.DistrictOptions = districtData.District__c.map(item => {
          //  return { label: item, value: item };
            //this.DistrictOptions = districtData.District__c.split(';').map(item => {
            //  return { label: item, value: item };
            //});
            console.log(districtData);
            this.isDistrictDisabled = false;
        }
          //this.DistrictOptions = this.StateDistrictMapping.data.find(item => item.State__c === this.selectedState).District__c.split(';').map(item => {
          //    return {label: item, value: item};
         // });
        //  this.isDistrictDisabled = false;
      }
  }

  ratehandler(event) {
    this.Unitrate = event.target.value;
    if (this.Quantity !== undefined && this.Discountprice !== undefined && this.Unitrate !== undefined) {
      this.Totalprice = this.Quantity * this.Unitrate - this.Discountprice;
      //let discPrice=this.Discount*this.Unitrate*this.Quantity/100;
     /// let Totlprice=this.Unitrate*this.Quantity-this.Discountprice;
      ///let val = this.template.querySelector('.ValJS');
      //val.value=discPrice;
      //let val1 = this.template.querySelector('.ValJ');
      //val1.value=Totlprice;
       let table = this.template.querySelector('table');
         let rowNumber = table.rows.length-1;
      this.rows[rowNumber].Totalprice.value = this.Quantity * this.Unitrate - this.Discountprice;

    }
  }

  quantityhandler(event) {
    this.Quantity = event.target.value;
    if (typeof this.Unitrate !== "undefined" ) {
        let discPrice = this.Discount * this.Unitrate * this.Quantity / 100;
        let Totlprice = this.Unitrate * this.Quantity; //- this.Discountprice;
        this.Totalprice = Totlprice;
        let table = this.template.querySelector('table');
        let rowNumber = table.rows.length - 1;
        console.log(rowNumber);
        this.rows[rowNumber].Total = Totlprice;
        console.log(this.rows[rowNumber].Total);
    }
}



discounthandler(event)
{
    
    if(this.Unitrate!="undefined" && this.Quantity!="undefined")
    {
       this.Discount=event.target.value;
       this.Discountprice=this.Discount*this.Unitrate*this.Quantity/100;
       this.Totalprice=this.Unitrate*this.Quantity-this.Discountprice;
       let discPrice=this.Discount*this.Unitrate*this.Quantity/100;
      let Totlprice=this.Unitrate*this.Quantity-this.Discountprice;
      let table = this.template.querySelector('table');
         let rowNumber = table.rows.length-1;
      this.rows[rowNumber].Totalprice.value = this.Quantity * this.Unitrate - this.Discountprice;


    }
}


        handleAccountSelection(event){
            this.selectedAccount = event.target.value;
            alert("The selected Accout id is"+this.selectedAccount);
        }
        HandleFocus(){
            if(this.selectedAccount==""){ 
                    alert("Please Select Party First");
            }
        }
@wire(getObjectInfo, { objectApiName: SALE_INVOICE_OBJECT })
    SaleInvoiceInfo;

    @wire(getPicklistValues,
        {
            recordTypeId: '$SaleInvoiceInfo.data.defaultRecordTypeId',
            fieldApiName: DISTRICT_FIELD
        }
    )
    DistrictValues;

    @wire(getPicklistValues,
        {
            recordTypeId: '$SaleInvoiceInfo.data.defaultRecordTypeId',
            fieldApiName: STATE_FIELD
        }
    )
    StateValues;
    

/*
  handleProductNameChange(event) {
    this.productName = event.target.value;
  }

  handleQuantityChange(event) {
    this.quantity = event.target.value;
  }

  handleUnitPriceChange(event) {
    this.unitPrice = event.target.value;
  }

  handleDescriptionChange(event) {
    this.description = event.target.value;
  }*/

  handleAddLineItem() {
    let table = this.template.querySelector('table');
    this.Totalprice=0;
    this.Quantity=0;
    this.Unitrate=0;
     this.Discount=0;
    this.Discountprice=0;
    let rowNumber = table.rows.length;

    this.rows.push({ SrNo:rowNumber, item: '', description: '',  quantity: '', UoM: '',  rate: '', Discount: '',DiscountPrice: '', Total: '' });
   
  } 
}