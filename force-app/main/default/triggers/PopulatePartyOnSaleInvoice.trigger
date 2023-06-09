trigger PopulatePartyOnSaleInvoice on Sale_Invoice__c (before insert, after insert)
{
    if(trigger.isBefore && trigger.isInsert){
        Set<String> farmerCodes = new Set<String>();
        for(Sale_Invoice__c ObjSaleInv: trigger.new){
            String farmerCode;
          if(ObjSaleInv.Party_name__C!=null ||ObjSaleInv.Party_name__C!=''){
              String s1 = ObjSaleInv.Party_name__C;
              String s2 = s1.substringBefore('(');
              farmerCode=s2.remove(' ');
              farmerCodes.add(farmerCode);
              
          }
            
        }
       
    // Query for existing Client Farmer records with matching Farmer Codes
    Map<String, account> FarmerCodecFarmerMap = new Map<String, account>();
    list<account>ExistingFarmerList=[select id,name,Farmer_Code__c from account where Farmer_Code__c IN:farmerCodes ];
    if(ExistingFarmerList.size()>0)
    {
       for (account clientFarmer : ExistingFarmerList) 
       {
        FarmerCodecFarmerMap.put(clientFarmer.Farmer_Code__c, clientFarmer);
       }
    }   
    
    for (Sale_Invoice__c invoice : Trigger.new) {
            String farmerCode;
            String FarmerName;
          if(invoice.Party_name__C!=null ||invoice.Party_name__C!=''){
              String s1 = invoice.Party_name__C;
              String s2 = s1.substringBefore('(');
              farmerCode=s2.remove(' ');
              FarmerName=invoice.Party_name__C.substringBetween('(',')');
              invoice.Farmer_code__c=farmerCode;
              invoice.Party_name__C=FarmerName;
        if (FarmerCodecFarmerMap.containsKey(invoice.Farmer_Code__c)) 
        {
            invoice.Client_Farmer__c = FarmerCodecFarmerMap.get(invoice.Farmer_Code__c).Id;
            
        }
    }  
    }  
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if(trigger.IsAfter && trigger.isInsert){
        set<String>Farmercodes=new Set<String>();
    List<Sale_Invoice__c>InvoiceListToUpdate=new List<Sale_Invoice__c>();  
    list<account>ClientFarmerList=new list<account>();
    // Collect all unique Farmer Codes from the SaleInvoices being inserted 
    for (Sale_Invoice__c invoice : Trigger.new) {
        farmerCodes.add(invoice.Farmer_Code__c);
    }
    // Query for existing Client Farmer records with matching Farmer Codes
    Map<String, account> clientFarmers = new Map<String, account>();
        Map<String, account> NewclientFarmers = new Map<String, account>();
    list<account>ExistingFarmerList=[select id,name,Farmer_Code__c from account where Farmer_Code__c IN:farmerCodes ];
    if(ExistingFarmerList.size()>0)
    {
       for (account clientFarmer : ExistingFarmerList) 
       {
        clientFarmers.put(clientFarmer.Farmer_Code__c, clientFarmer);
       }
    }   
    // Create a new Client Farmer if it doesn't exist, and populate lookup field in SaleInvoice
    for (Sale_Invoice__c invoice : Trigger.new) {
        if (!clientFarmers.containsKey(invoice.Farmer_Code__c)) 
        {
            // Create a new Client Farmer record
                Account newClientFarmer=new Account();
                newClientFarmer.Farmer_Code__c=invoice.Farmer_Code__c;
                newClientFarmer.Name = invoice.Party_name__c;
                newClientFarmer.Phone = invoice.Phone__c;    
                ClientFarmerList.add(newClientFarmer);
            // Update the lookup field on the SaleInvoice to the newly created Client Farmer record
             //invoice.Party__c = newClientFarmer.Id;
        } 
    }  
        
        if(ClientFarmerList.size()>0){
            insert ClientFarmerList;
          for(Account CF:ClientFarmerList){
            NewclientFarmers.put(CF.Farmer_Code__c, CF);
        }
            for (Sale_Invoice__c invoice : Trigger.new) {
                if(NewclientFarmers.containskey(invoice.Farmer_Code__c)){
                    Sale_Invoice__c SI=new Sale_Invoice__c();
                SI.Id=invoice.id;
                SI.Client_Farmer__c=NewclientFarmers.get(invoice.Farmer_Code__c).Id;
                    InvoiceListToUpdate.add(SI);
                }
                
            }
        }
        if(InvoiceListToUpdate.size()>0){
            update InvoiceListToUpdate;
        }
    }
   
}