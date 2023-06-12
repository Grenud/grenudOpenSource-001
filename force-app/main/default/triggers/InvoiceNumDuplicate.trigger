trigger InvoiceNumDuplicate on Sale_Invoice__c (before insert)
{
   /* if(trigger.isbefore && trigger.isinsert)
    {
 	 SaleInvoiceHandler.PreventDuplicateInvoiveNumber(trigger.new);
	}*/
}