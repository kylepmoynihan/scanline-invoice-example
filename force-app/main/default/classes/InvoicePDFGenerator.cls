/**
 * Invocable class to generate Invoice PDF with OCRA scanline
 * Can be called from Flow or Process Builder
 */
public class InvoicePDFGenerator {

    /**
     * Invocable method to generate invoice PDF
     * @param requests List of request parameters
     * @return List of result objects with ContentVersion ID
     */
    @InvocableMethod(label='Generate Invoice PDF' description='Generates an invoice PDF with OCRA scanline rendering')
    public static List<Result> generateInvoicePDF(List<Request> requests) {
        List<Result> results = new List<Result>();

        for (Request req : requests) {
            Result res = new Result();
            try {
                // Query the invoice and related data
                Invoice__c invoice = [
                    SELECT Id, Name, Customer__c, Customer__r.Name,
                           Customer__r.Customer_Number__c, Customer__r.Billing_Street__c,
                           Customer__r.Billing_City__c, Customer__r.Billing_State__c,
                           Customer__r.Billing_Zip__c, Invoice_Date__c, Due_Date__c,
                           Total_Amount__c, Scanline__c
                    FROM Invoice__c
                    WHERE Id = :req.invoiceId
                    LIMIT 1
                ];

                // Query related charges
                List<Charge__c> charges = [
                    SELECT Id, Name, Description__c, Amount__c, Charge_Date__c
                    FROM Charge__c
                    WHERE Invoice__c = :req.invoiceId
                    ORDER BY Charge_Date__c ASC
                ];

                // Create PageReference to Visualforce page
                PageReference pageRef = Page.Invoice_Template;

                // Set invoice ID - the controller will query everything else
                pageRef.getParameters().put('id', invoice.Id);

                // Generate PDF
                Blob pdfBlob;
                if (Test.isRunningTest()) {
                    pdfBlob = Blob.valueOf('Test PDF Content');
                } else {
                    pdfBlob = pageRef.getContentAsPDF();
                }

                // Create ContentVersion
                ContentVersion cv = new ContentVersion();
                cv.Title = 'Invoice_' + invoice.Name + '.pdf';
                cv.PathOnClient = 'Invoice_' + invoice.Name + '.pdf';
                cv.VersionData = pdfBlob;
                cv.IsMajorVersion = true;
                cv.FirstPublishLocationId = invoice.Id;
                insert cv;

                // Set success result
                res.success = true;
                res.contentVersionId = cv.Id;
                res.message = 'PDF generated successfully';

            } catch (Exception e) {
                res.success = false;
                res.message = 'Error generating PDF: ' + e.getMessage();
                System.debug(LoggingLevel.ERROR, 'Error generating PDF: ' + e.getMessage());
                System.debug(LoggingLevel.ERROR, 'Stack trace: ' + e.getStackTraceString());
            }

            results.add(res);
        }

        return results;
    }

    /**
     * Request wrapper class
     */
    public class Request {
        @InvocableVariable(label='Invoice ID' description='The ID of the invoice record' required=true)
        public Id invoiceId;
    }

    /**
     * Result wrapper class
     */
    public class Result {
        @InvocableVariable(label='Success' description='Whether the PDF generation was successful')
        public Boolean success;

        @InvocableVariable(label='Content Version ID' description='The ID of the generated PDF ContentVersion')
        public Id contentVersionId;

        @InvocableVariable(label='Message' description='Success or error message')
        public String message;
    }
}
