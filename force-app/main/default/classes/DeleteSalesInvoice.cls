public class DeleteSalesInvoice {

    public static void DeleteRecord(){
       Delete [SELECT Id, Name FROM Sale_Invoice__c where name like 'INV%'];
 
    }
}