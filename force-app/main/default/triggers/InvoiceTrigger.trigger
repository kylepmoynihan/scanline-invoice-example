/**
 * Trigger on Invoice__c object
 * Auto-generates scanline before insert/update
 */
trigger InvoiceTrigger on Invoice__c (before insert, before update) {

    // Collect all customer IDs that need to be queried
    Set<Id> customerIds = new Set<Id>();
    for (Invoice__c invoice : Trigger.new) {
        if (invoice.Customer__c != null && invoice.Total_Amount__c != null) {
            customerIds.add(invoice.Customer__c);
        }
    }

    // Query all customers at once (bulkified)
    Map<Id, Customer__c> customerMap = new Map<Id, Customer__c>([
        SELECT Id, Customer_Number__c
        FROM Customer__c
        WHERE Id IN :customerIds
    ]);

    // Generate scanlines
    for (Invoice__c invoice : Trigger.new) {
        if (invoice.Customer__c != null && invoice.Total_Amount__c != null) {
            Customer__c customer = customerMap.get(invoice.Customer__c);

            if (customer != null && customer.Customer_Number__c != null) {
                // Generate scanline
                invoice.Scanline__c = InvoiceService.generateScanline(
                    customer.Customer_Number__c,
                    invoice.Total_Amount__c
                );
            }
        }
    }
}
