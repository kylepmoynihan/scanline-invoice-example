/**
 * Controller for Invoice_Template Visualforce page
 * Provides all invoice and charge data for PDF rendering
 */
public class InvoiceTemplateController {
    public Invoice__c invoice { get; set; }
    public List<Charge__c> charges { get; set; }

    public InvoiceTemplateController() {
        String invoiceId = ApexPages.currentPage().getParameters().get('id');

        if (String.isNotBlank(invoiceId)) {
            // Query invoice with customer details
            List<Invoice__c> invoices = [
                SELECT Id, Name, Customer__c, Customer__r.Name,
                       Customer__r.Customer_Number__c, Customer__r.Billing_Street__c,
                       Customer__r.Billing_City__c, Customer__r.Billing_State__c,
                       Customer__r.Billing_Zip__c, Invoice_Date__c, Due_Date__c,
                       Total_Amount__c, Scanline__c
                FROM Invoice__c
                WHERE Id = :invoiceId
                LIMIT 1
            ];

            if (!invoices.isEmpty()) {
                invoice = invoices[0];

                // Query related charges
                charges = [
                    SELECT Id, Name, Description__c, Amount__c, Charge_Date__c
                    FROM Charge__c
                    WHERE Invoice__c = :invoiceId
                    ORDER BY Charge_Date__c ASC
                ];
            }
        }
    }
}
