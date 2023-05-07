import { LightningElement } from 'lwc';
export default class CalculationComponent extends LightningElement {
Unitrate ;
Quantity;
Discount;
Totalprice;
Discountprice;

ratehandler(event) {
  this.Unitrate = event.target.value;
  if (this.Quantity !== undefined && this.Discountprice !== undefined && this.Unitrate !== undefined) {
    this.Totalprice = this.Quantity * this.Unitrate - this.Discountprice;
  }
}


quantityhandler(event)
{
    this.Quantity=event.target.value
    if (this.Unitrate!="undefined")
 {
this.Totalprice=this.Quantity*this.Unitrate-this.Discountprice;
console.log(this.Totalprice)
console.log(this.Quantity)
 }
}
discounthandler(event)
{
    
    if(this.Unitrate!="undefined" && this.Quantity!="undefined")
    {
       this.Discount=event.target.value;
       this.Discountprice=this.Discount*this.Unitrate*this.Quantity/100;
       this.Totalprice=this.Unitrate*this.Quantity-this.Discountprice;
      console.log(this.Discountprice)
      console.log(this.Unitrate)
      console.log(this.Quantity)

      

    }
}
}