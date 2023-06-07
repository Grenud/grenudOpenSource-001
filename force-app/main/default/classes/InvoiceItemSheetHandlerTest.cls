@isTest
public class InvoiceItemSheetHandlerTest {
    @isTest
    public static void testHandlerAfterInsert() {
        List<Sale_Invoice__c> invoiceList = new List<Sale_Invoice__c>();
        Sale_Invoice__c invoice1 = new Sale_Invoice__c();
        invoice1.Name = 'INV001';
        invoice1.Vyapar_INV_No__c='INV001';
        invoiceList.add(invoice1);
        
        Sale_Invoice__c invoice2 = new Sale_Invoice__c();
        invoice2.Name = 'INV002';
         invoice2.Vyapar_INV_No__c='INV002';
        invoiceList.add(invoice2);
        
        insert invoiceList;
        // Create test data
        List<Invoice_Item_Sheet__c> invoiceItemSheetList = new List<Invoice_Item_Sheet__c>();
        Invoice_Item_Sheet__c invoiceItem1 = new Invoice_Item_Sheet__c();
        invoiceItem1.Invoice_Number__c = 'INV001';
        invoiceItemSheetList.add(invoiceItem1);
        
        Invoice_Item_Sheet__c invoiceItem2 = new Invoice_Item_Sheet__c();
        invoiceItem2.Invoice_Number__c = 'INV002';
        invoiceItemSheetList.add(invoiceItem2);
        
        // Insert test data
        Test.startTest();
        InvoiceItemSheetHandler.HandlerAfterInsert(invoiceItemSheetList);
        Test.stopTest();
        
        // Perform assertions
        List<Product_Item__c> productItems = [SELECT Id, Sale_Invoice__c, Vyapar_INV_No__c FROM Product_Item__c];
        string InvoiceINV001=[Select id from Sale_Invoice__c where name = 'INV001'].id;
        string InvoiceINV002=[Select id from Sale_Invoice__c where name = 'INV002'].id;
        System.assertEquals(2, productItems.size());
        
        for (Product_Item__c productItem : productItems) {
            if (productItem.Vyapar_INV_No__c == 'INV001') {
                 system.assertEquals(InvoiceINV001,productItem.Sale_Invoice__c);
                System.assertEquals(invoiceItem1.Invoice_Number__c, productItem.Vyapar_INV_No__c);
            } else if (productItem.Vyapar_INV_No__c == 'INV002') {
                   system.assertEquals(InvoiceINV002,productItem.Sale_Invoice__c);
                System.assertEquals(invoiceItem2.Invoice_Number__c, productItem.Vyapar_INV_No__c);
            }
        }
    }
}