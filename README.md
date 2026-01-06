# Salesforce Invoice Generation with OCRA Scanline

A complete Salesforce solution for generating professional invoices with OCR-readable scanlines. This system automatically creates PDF invoices from unbilled charges and includes machine-readable payment processing codes using the OCRA font.

## Features

- **Automated Invoice Generation**: Screen Flow that creates invoices from unbilled charges
- **OCRA Scanline**: Auto-generated scanlines with check digits for payment processing
- **PDF Generation**: Professional invoice PDFs with proper formatting
- **Quick Action**: Generate invoices directly from Customer records
- **Bulkified Code**: All Apex follows Salesforce best practices

## Solution Components

### Custom Objects
- **Customer__c**: Customer records with billing information
- **Invoice__c**: Invoice records with scanline generation
- **Charge__c**: Individual charges that get billed to invoices

### Apex Classes
- `InvoiceService` - Core business logic for scanline generation using modulo 10 weighted sum algorithm
- `InvoiceTemplateController` - Visualforce controller for PDF template
- `InvoicePDFGenerator` - Invocable Apex for PDF generation from Flow
- `OCRAScanlineController` - Component controller for OCRA font rendering

### Visualforce
- `Invoice_Template.page` - Professional invoice PDF template
- `OCRA_Scanline.component` - Scanline rendering component using OCRA font images

### Automation
- `InvoiceTrigger` - Auto-generates scanlines on invoice creation/update
- `Generate_Invoice` Flow - User-friendly invoice generation process
- Quick Action on Customer object

### Static Resources
- OCRA font digit images (0-9) for scanline rendering

## Scanline Format

The scanline follows this structure:
```
[Routing: 5 digits][Customer Number: 10 digits][Amount in cents: 8 digits][Check Digit: 1 digit]
```

**Example**: `123450000000005007500000`
- Routing: `12345`
- Customer: `0000000005` (C-00005)
- Amount: `00750000` ($7,500.00)
- Check: `0` (calculated using modulo 10 weighted sum)

## Key Technical Details

### PDF Rendering Limitations
Salesforce's PDF rendering engine (Flying Saucer/iText) has limitations:
- ✅ **Works**: Inline padding, margin, font-size
- ❌ **Doesn't Work**: CSS in `<style>` blocks, colors, complex borders
- **Solution**: All formatting uses inline styles

### Code Quality
- Bulkified triggers (no SOQL in loops)
- Proper exception handling
- List-based SOQL queries to avoid exceptions
- Comprehensive comments

## Installation

1. Deploy custom objects and fields
2. Deploy Apex classes and triggers
3. Deploy Visualforce pages and components
4. Upload OCRA font static resources
5. Deploy Flow and Quick Action
6. Assign Invoice_Management permission set to users

## Usage

1. Navigate to a Customer record
2. Click the "Generate Invoice" Quick Action
3. Review unbilled charges and total amount
4. Click "Generate Invoice"
5. PDF invoice with scanline is automatically created and attached

## Demo Data

Use the included `create-new-customer-and-charges.apex` script to create sample data:
- Creates Horizon Technologies customer
- Adds 3 unbilled charges totaling $7,500.00
- Ready for invoice generation testing

## Author

Built as a portfolio demonstration of Salesforce development capabilities.

## License

MIT License - Free to use and modify
