trigger PopulatePartyOnSaleInvoice on Sale_Invoice__c (before insert, after insert)
{
    if(trigger.isBefore && trigger.isInsert){
        
        for(Sale_Invoice__c ObjSaleInv: trigger.new){
            system.debug(ObjSaleInv.Party_name__C);
            String s1 = ObjSaleInv.Party_name__C;
            String s2 = s1.substringBefore('(');
            s2=s2.remove(' ');
            ObjSaleInv.Farmer_Code__c=s2;
        }
    }
    if(trigger.IsAfter && trigger.isInsert){
    List<Sale_Invoice__c>InvoiceListToUpdate=new List<Sale_Invoice__c>();  
    list<account>ClientFarmerList=new list<account>();
    // Collect all unique Farmer Codes from the SaleInvoices being inserted
    Set<String> farmerCodes = new Set<String>();
    for (Sale_Invoice__c invoice : Trigger.new) {
        farmerCodes.add(invoice.Farmer_Code__c);
    }
    // Query for existing Client Farmer records with matching Farmer Codes
    Map<String, account> clientFarmers = new Map<String, account>();
    list<account>FarmerCodeList=[select id,name,Farmer_Code__c from account where Farmer_Code__c IN:farmerCodes ];
    if(FarmerCodeList.size()>0)
    {
       for (account clientFarmer : FarmerCodeList) 
       {
        clientFarmers.put(clientFarmer.Farmer_Code__c, clientFarmer);
       }
    }   
    // Create a new Client Farmer if it doesn't exist, and populate lookup field in SaleInvoice
    for (Sale_Invoice__c invoice : Trigger.new) {
        if (!clientFarmers.containsKey(invoice.Farmer_Code__c)) {
            // Create a new Client Farmer record
                Account newClientFarmer=new Account();
                newClientFarmer.Farmer_Code__c=invoice.Farmer_Code__c;
                newClientFarmer.Name = invoice.Name;
                newClientFarmer.Phone = invoice.Phone__c;    
                ClientFarmerList.add(newClientFarmer);
            // Update the lookup field on the SaleInvoice to the newly created Client Farmer record
             //invoice.Party__c = newClientFarmer.Id;
        } else {
            // If an existing Client Farmer record is found, update the lookup field on the Sale Invoice
            Sale_Invoice__c Inv = new Sale_Invoice__c();
            Inv.Client_Farmer__c = clientFarmers.get(invoice.Farmer_Code__c).Id;
            Inv.id=invoice.Id;
            InvoiceListToUpdate.add(Inv);
        }
    }  
        if(InvoiceListToUpdate.size()>0){
           Update InvoiceListToUpdate;  
        }
        if(ClientFarmerList.size()>0){
            insert ClientFarmerList;
            
        }
       
    }
   
}