trigger PopulatePartyOnSaleInvoice on Sale_Invoice__c (before insert, after insert)
{
    if(trigger.isBefore && trigger.isInsert)
    {
       SaleInvoiceTriggerHandler.PopulateFarmerCodes(trigger.new);
       SaleInvoiceTriggerHandler.PreventDuplicateInvoiveNumber(trigger.new);
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if(trigger.IsAfter && trigger.isInsert)
    {
      SaleInvoiceTriggerHandler.PopulatePartySaleInvoice(trigger.new);
    }
   
}