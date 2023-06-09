public class SaleInvoiceTriggerHandler
{
    Public static void updateTotalInvRollupsum(List<Sale_Invoice__c>FCList){
        Set<string>ClientFarmerId=new Set<String>();
        for(Sale_Invoice__c SI:FCList){
            if(SI.Client_farmer__c!=null){
                ClientFarmerId.add(SI.Client_farmer__c);
                
            }
        }
        
        Map<Id, Decimal> accountTotalCreditMap = new Map<Id, Decimal>();
         Map<Id, integer> accountInvoiceCount = new Map<Id, integer>();
        List<Account> accountsToUpdate = [SELECT Id,Total_Invoice_Value__c FROM Account WHERE Id IN :ClientFarmerId];
        list<Account>CFList=[Select Id, (SELECT Total_Invoice_Value__c FROM Sale_Invoices__r) from Account where id in:ClientFarmerId];
        
        for (Account acc : accountsToUpdate) {
            accountTotalCreditMap.put(acc.Id, 0);
            accountInvoiceCount.put(acc.Id,0);
        }
        
        for (Sale_Invoice__c CF : [SELECT Client_farmer__c, Total_Invoice_Value__c FROM Sale_Invoice__c WHERE Client_farmer__c IN :ClientFarmerId]) {
            accountTotalCreditMap.put(CF.Client_farmer__c, accountTotalCreditMap.get(CF.Client_farmer__c) + CF.Total_Invoice_Value__c);
        	accountInvoiceCount.put(CF.Client_farmer__c, accountInvoiceCount.get(CF.Client_farmer__c) + 1);
        }
        List<Account> accountsToUpdateWithRollup = new List<Account>();
        for (Account acc : accountsToUpdate) {
            Decimal totalCreditValue = accountTotalCreditMap.get(acc.Id);
            acc.Total_Invoice_Value__c = totalCreditValue;
            acc.Total_Sale_Invoice_Count__c=accountInvoiceCount.get(acc.Id);
            accountsToUpdateWithRollup.add(acc);
        }
        
        if (!accountsToUpdateWithRollup.isEmpty()) {
            update accountsToUpdateWithRollup;
        }
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    Public static void UpdateReparentTotalInvRollUpSum(list<Sale_Invoice__c>OldList, List<Sale_Invoice__c>NewList, map<id,Sale_Invoice__c>SIoldmap){
        Set<string>ClientFarmerId=new Set<String>();
        for(Sale_Invoice__c SI:NewList){
            if(SI.Client_farmer__c!= SIoldmap.get(SI.id).Client_farmer__c){
                ClientFarmerId.add(SI.Client_farmer__c);
                if(SIoldmap.get(SI.id).Client_farmer__c!=null){
                 ClientFarmerId.add(SIoldmap.get(SI.id).Client_farmer__c);   
                }
                
            }
        }
        if(ClientFarmerId.size()>0){
            //list<String, list<Sale_Invoice__c>>
        Map<Id, Decimal> accountTotalInvoiceMap = new Map<Id, Decimal>();
        Map<Id, integer> accountInvoiceCount = new Map<Id, integer>();
        List<Account> accountsToUpdate = [SELECT Id FROM Account WHERE Id IN :ClientFarmerId];
        list<Account>CFList=[Select Id, (SELECT Total_Invoice_Value__c FROM Sale_Invoices__r) from Account where id in:ClientFarmerId];
        
        if(accountsToUpdate.size()>0){
          for (Account acc : accountsToUpdate) {
            accountTotalInvoiceMap.put(acc.Id, 0);
            accountInvoiceCount.put(acc.Id,0);
        }  
        }
        
        for (Sale_Invoice__c invoice : [SELECT Client_farmer__c, Total_Invoice_Value__c FROM Sale_Invoice__c WHERE Client_farmer__c IN :ClientFarmerId]) {
            System.debug('invoice.Client_farmer__c'+invoice.Client_farmer__c+'accountTotalInvoiceMap.get(invoice.Client_farmer__c)@'+accountTotalInvoiceMap.get(invoice.Client_farmer__c)+'ANd invoice.Total_Invoice_Value__c'+invoice.Total_Invoice_Value__c);
            accountTotalInvoiceMap.put(invoice.Client_farmer__c, accountTotalInvoiceMap.get(invoice.Client_farmer__c) + invoice.Total_Invoice_Value__c);
            accountInvoiceCount.put(invoice.Client_farmer__c, accountInvoiceCount.get(invoice.Client_farmer__c) + 1);
        }
        List<Account> accountsToUpdateWithRollup = new List<Account>();
        for (Account acc : accountsToUpdate) {
            Decimal totalInvoiceValue = accountTotalInvoiceMap.get(acc.Id);
            acc.Total_Invoice_Value__c = totalInvoiceValue;
            acc.Total_Sale_Invoice_Count__c=accountInvoiceCount.get(acc.Id);
            accountsToUpdateWithRollup.add(acc);
        }
        
        if (!accountsToUpdateWithRollup.isEmpty()) {
            update accountsToUpdateWithRollup;
        }   
        }
       
    }
    public static void PopulateFarmerCodes(List<Sale_Invoice__c>FarmerCodeSaleInvoice)
    {
        Set<String> farmerCodes = new Set<String>();
        for(Sale_Invoice__c ObjSaleInv: FarmerCodeSaleInvoice)
        {
            String farmerCode;
            if(ObjSaleInv.Party_name__C!=null ||ObjSaleInv.Party_name__C!='')
            {
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
        
        for (Sale_Invoice__c invoice : FarmerCodeSaleInvoice)
        {
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
                    invoice.Client_Farmer__c = FarmerCodecFarmerMap.get(invoice.Farmer_Code__c).Id;                    }
            }  
        }  
    }
    
    public static void PopulatePartySaleInvoice(List<Sale_Invoice__c>SaleInvoiceNewList) 
    {
        set<String>Farmercodes=new Set<String>();
        List<Sale_Invoice__c>InvoiceListToUpdate=new List<Sale_Invoice__c>();  
        list<account>ClientFarmerList=new list<account>();
        // Collect all unique Farmer Codes from the SaleInvoices being inserted 
        for (Sale_Invoice__c invoice : SaleInvoiceNewList) {
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
        map<String, Account>FarmercodewiseClientMap=new map<String, Account>();
        for (Sale_Invoice__c invoice : SaleInvoiceNewList) {
            if (!clientFarmers.containsKey(invoice.Farmer_Code__c)) 
            {
                // Create a new Client Farmer record
                Account newClientFarmer=new Account();
                newClientFarmer.Farmer_Code__c=invoice.Farmer_Code__c;
                System.debug(invoice.Party_name__c);
                    newClientFarmer.Name = invoice.Party_name__c;
                  //////////////////////////////////////
                newClientFarmer.Phone = invoice.Phone__c;    
                //ClientFarmerList.add(newClientFarmer);
                FarmercodewiseClientMap.put(invoice.Farmer_Code__c,newClientFarmer);
                // Update the lookup field on the SaleInvoice to the newly created Client Farmer record
                //invoice.Party__c = newClientFarmer.Id;
            } 
        }  
        ClientFarmerList.addAll(FarmercodewiseClientMap.values());
        if(ClientFarmerList.size()>0){
            insert ClientFarmerList;
            for(Account CF:ClientFarmerList){
                NewclientFarmers.put(CF.Farmer_Code__c, CF);
            }
            for (Sale_Invoice__c invoice : SaleInvoiceNewList) {
                if(NewclientFarmers.containskey(invoice.Farmer_Code__c)){
                    Sale_Invoice__c SI=new Sale_Invoice__c();
                    SI.Id=invoice.id;
                    //SI.Name=invoice.Name;
                    SI.Client_Farmer__c=NewclientFarmers.get(invoice.Farmer_Code__c).Id;
                    InvoiceListToUpdate.add(SI);
                }
                
            }
        }
        if(InvoiceListToUpdate.size()>0){
            update InvoiceListToUpdate;
        }
        Map<String, account> NewPlusExisting = new Map<String, account>();
        NewPlusExisting.putAll(NewclientFarmers);
        NewPlusExisting.putAll(clientFarmers);
        createFarmerCredit(SaleInvoiceNewList,NewPlusExisting );
    }
    
    public static void PreventDuplicateInvoiveNumber(List<Sale_Invoice__c>SaleInvoiceList)
    {
        Set<String>setInvoiceNumber= new Set<String>();
        For(Sale_Invoice__c acc:SaleInvoiceList)
        {
            setInvoiceNumber.add(acc.name);
        }
        
        if(setInvoiceNumber.size() > 0 )
        {
            List<Sale_Invoice__c>ExistingInvList = [select name ,id from Sale_Invoice__c where name IN :setInvoiceNumber ];
            
            Map<String ,Sale_Invoice__c>InvoiceNumMap = new Map<String,Sale_Invoice__c>();
            For(Sale_Invoice__c objInv: ExistingInvList)
            {
                InvoiceNumMap.put(objInv.name ,objInv);
            }
            
            For(Sale_Invoice__c objInv :SaleInvoiceList)
            {
                if(InvoiceNumMap.containsKey(objInv.name))
                {
                    objInv.Name.addError('Invoice Number already Exist ');
                }
            }
        }		
    }
    public static void createFarmerCredit(List<Sale_Invoice__c>NewSaleInvList, Map<String, account> NewPlusExisting){
        list<Farmer_credit__c>FCtoInsert=new List<Farmer_Credit__c>();
        for(Sale_Invoice__c SI:NewSaleInvList){
            if(SI.Payment_Type__c=='Cheque'){
                Farmer_credit__c Fc= new Farmer_credit__c();
                //system.debug('SI.Client_Farmer__c'+SI.Client_Farmer__c);
                Fc.Client_Farmer__c=NewPlusExisting.get(SI.Farmer_Code__c).id;//SI.Client_Farmer__c;
                Fc.Farmer_Code__c=SI.Farmer_Code__c;
                Fc.Father_Name__c=SI.Father_Name__c;
                Fc.Sale_Invoice__c=SI.id;
                Fc.Invoice_Number__c=SI.name;
                Fc.Balance_Due__c=SI.Total_Invoice_Value__c;
                Fc.Phone__c=SI.Phone__c;
                Fc.Total_Invoice_Value__c=SI.Total_Invoice_Value__c;
                FCtoInsert.add(Fc);
            }
        }
        
        if(FCtoInsert.size()>0){
            insert FCtoInsert; 
        }
    }
   ////////////////////////////////////////////////////////////////////////////////////////////
    public static void createFarmerCreditupdatecashtocheque(List<Sale_Invoice__c>NewSaleInvList,map<id,Sale_Invoice__c>oldmap){
        list<Farmer_credit__c>FCtoInsert=new List<Farmer_Credit__c>();
        for(Sale_Invoice__c SI:NewSaleInvList){
            if(SI.Payment_Type__c=='Cheque'&& oldmap.get(si.id).Payment_Type__c=='Cash'){
                Farmer_credit__c Fc= new Farmer_credit__c();
                system.debug('SI.Client_Farmer__c'+SI.Client_Farmer__c);
                Fc.Client_Farmer__c=SI.Client_Farmer__c;
                Fc.Farmer_Code__c=SI.Farmer_Code__c;
                Fc.Father_Name__c=SI.Father_Name__c;
                Fc.Sale_Invoice__c=SI.id;
                Fc.Invoice_Number__c=SI.name;
                Fc.Balance_Due__c=SI.Total_Invoice_Value__c;
                Fc.Phone__c=SI.Phone__c;
                Fc.Total_Invoice_Value__c=SI.Total_Invoice_Value__c;
                FCtoInsert.add(Fc);
            }
        }
        if(FCtoInsert.size()>0){
            insert FCtoInsert; 
        }
    }
}