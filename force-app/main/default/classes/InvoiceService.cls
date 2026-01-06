/**
 * Service class for Invoice operations
 * Handles scanline generation and check digit calculation
 */
public class InvoiceService {

    private static final String SCANLINE_PREFIX = '12345';

    /**
     * Generates scanline for an invoice
     * Format: [Routing#][Customer#][Amount][CheckDigit]
     * @param customerNumber 10-digit customer number
     * @param totalAmount Invoice total amount
     * @return Generated scanline string
     */
    public static String generateScanline(String customerNumber, Decimal totalAmount) {
        // Extract numeric portion only (remove any prefix like "C-")
        String numericOnly = customerNumber.replaceAll('[^0-9]', '');

        // Ensure customer number is 10 digits (pad with zeros if needed)
        String paddedCustomerNumber = numericOnly.leftPad(10, '0');

        // Convert amount to 8-digit string (including 2 decimal places)
        // Example: 1500.00 becomes 00015000
        Long amountInCents = (totalAmount * 100).longValue();
        String paddedAmount = String.valueOf(amountInCents).leftPad(8, '0');

        // Build scanline without check digit
        String scanlineWithoutCheck = SCANLINE_PREFIX + paddedCustomerNumber + paddedAmount;

        // Calculate check digit
        String checkDigit = calculateCheckDigit(scanlineWithoutCheck);

        // Return complete scanline
        return scanlineWithoutCheck + checkDigit;
    }

    /**
     * Calculates check digit using Modulo 10 algorithm
     * @param scanline Scanline string without check digit
     * @return Check digit as string
     */
    public static String calculateCheckDigit(String scanline) {
        Integer sum = 0;

        // Remove asterisks and process only digits
        String digitsOnly = scanline.replaceAll('[^0-9]', '');

        // Calculate weighted sum (alternating weights of 3 and 1 from right to left)
        for (Integer i = digitsOnly.length() - 1; i >= 0; i--) {
            Integer digit = Integer.valueOf(digitsOnly.substring(i, i + 1));
            Integer weight = Math.mod(digitsOnly.length() - 1 - i, 2) == 0 ? 3 : 1;
            sum += digit * weight;
        }

        // Check digit is the value needed to make sum divisible by 10
        Integer checkDigit = Math.mod(10 - Math.mod(sum, 10), 10);

        return String.valueOf(checkDigit);
    }
}
