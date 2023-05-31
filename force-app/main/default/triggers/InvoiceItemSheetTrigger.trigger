trigger InvoiceItemSheetTrigger on Invoice_Item_Sheet__c (after insert) 
{
 if(trigger.isafter && trigger.isinsert)
 {
     list<Product_Item__c>ItemtoInsertList=new list<Product_Item__c>();
     set<string>InvoiceNoSet=new set<string>();
     map<string, string>InvoiceNameIdMap=new map<string, string>();
     for(Invoice_Item_Sheet__c ObjInv:trigger.new)
     {
         if(ObjInv.Invoice_Number__c!=null)
         {
             InvoiceNoSet.add(ObjInv.Invoice_Number__c);
         }
         
     }
     list<Sale_Invoice__c>InvoiceList=[select id,name from Sale_Invoice__c where name IN : InvoiceNoSet];  
     if(InvoiceList.size()>0){
          for(Sale_Invoice__c ObjInv:InvoiceList )
          {
              InvoiceNameIdMap.put(ObjInv.Name,ObjInv.Id);
          }
     }
    for(Invoice_Item_Sheet__c ObjInv:trigger.new)
    {
        Product_Item__c objItem=new Product_Item__c();
        objItem.Sale_Invoice__c=InvoiceNameIdMap.get(ObjInv.Invoice_Number__c);
        objItem.Vyapar_INV_No__c=ObjInv.Invoice_Number__c;
        ItemtoInsertList.add(objItem);
    }
     insert ItemtoInsertList;
 }
}