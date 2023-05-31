trigger ProductItemTrigger on Product_Item__c (before insert) {
    
/* if(trigger.isbefore && trigger.isinsert)
 {
     system.debug('beforeTrigger executed');
     set<string>InvNoSet=new set<string>();
    map<string,string>InvNoIdMap = new map<string, string>();
     
     for(Product_Item__c ObjItem:trigger.new)
     {
         if(ObjItem.Vyapar_INV_No__c!=null)
         {
             system.debug(ObjItem.Vyapar_INV_No__c);
             
             InvNoSet.add(ObjItem.Vyapar_INV_No__c);
         }
     }
     
     //Collection for (Invoice Number Find from database for extraCTING THE id)
     List<Sale_Invoice__c> saleInvoiceRecord=[select id,name from Sale_Invoice__c where name IN : InvNoSet];
     if(SaleInvoiceRecord.size() > 0 ){
         for(Sale_Invoice__c ObjInvoice : SaleInvoiceRecord){
             system.debug(ObjInvoice.Id);
             system.debug(ObjInvoice.Name);
             InvNoIdMap.put(ObjInvoice.Name , ObjInvoice.Id);
             
         }
     } 
     
     for(Product_Item__c ObjItem:trigger.new){
         system.debug(InvNoIdMap.get(ObjItem.Sale_Invoice__c));
         ObjItem.Sale_Invoice__c = InvNoIdMap.get(ObjItem.Sale_Invoice__c);
         
        
     }
     
 }*/
}