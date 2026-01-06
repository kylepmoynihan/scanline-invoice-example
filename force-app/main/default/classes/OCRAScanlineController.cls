/**
 * Controller for OCRA_Scanline Visualforce component
 * Converts scanline string into individual characters for glyph rendering
 */
public class OCRAScanlineController {

    public String scanline { get; set; }

    /**
     * Returns list of individual characters from the scanline
     * Each character will be rendered as a separate image glyph
     */
    public List<String> getChars() {
        List<String> characters = new List<String>();

        if (String.isNotBlank(scanline)) {
            for (Integer i = 0; i < scanline.length(); i++) {
                String character = scanline.substring(i, i + 1);

                // Map asterisk to valid filename (can't use * as filename)
                if (character == '*') {
                    characters.add('asterisk');
                }
                // Only add characters that have corresponding glyph images
                // OCRAGlyphs contains: 0-9, A-Z, and asterisk
                else if (character.isNumeric() ||
                    (character >= 'A' && character <= 'Z')) {
                    characters.add(character);
                }
            }
        }

        return characters;
    }
}
