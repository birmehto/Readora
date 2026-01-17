class ReaderTheme {
  static const customCssId = 'custom-reader-style';

  static String getCss({
    required double fontSize,
    required bool isDarkMode,
    String fontFamily = 'Inter',
  }) {
    final bg = isDarkMode ? '#1a1c1e' : '#fdfcff';
    final fg = isDarkMode ? '#e2e2e6' : '#1a1c1e';
    final link = isDarkMode ? '#aec6ff' : '#005cbb';
    final codeBg = isDarkMode ? '#2c2c2c' : '#f0f0f0';
    final codeFg = isDarkMode ? '#e0e0e0' : '#333';
    final quote = isDarkMode ? '#64b5f6' : '#005cbb';
    final quoteText = isDarkMode ? '#b0bec5' : '#546e7a';
    final fallback = fontFamily == 'Merriweather' ? 'serif' : 'sans-serif';

    return '''
@import url('${_fontUrl(fontFamily)}');

html, body {
  background: $bg !important;
}

body {
  font-family: '$fontFamily', $fallback !important;
  font-size: ${fontSize}px !important;
  line-height: 1.6 !important;
  padding: 16px !important;
  color: $fg !important;
  max-width: 100% !important;
  box-sizing: border-box !important;
}

/* Normalize text */
body * {
  font: inherit !important;
  color: inherit !important;
  background: transparent !important;
  max-width: 100% !important;
  box-sizing: border-box !important;
}

/* Headings */
h1 { font-size: 2em !important; }
h2 { font-size: 1.5em !important; }
h3 { font-size: 1.25em !important; }
h4 { font-size: 1.1em !important; }
h5, h6 { font-size: 1em !important; }

h1,h2,h3,h4,h5,h6 {
  margin: 1.5em 0 .5em !important;
  font-weight: 600 !important;
  line-height: 1.3 !important;
}

/* Links */
a {
  color: $link !important;
  text-decoration: none !important;
}

/* Code */
pre, code {
  background: $codeBg !important;
  color: $codeFg !important;
  font-family: monospace !important;
  border-radius: 4px !important;
}

code { padding: 2px 4px !important; }
pre {
  padding: 12px !important;
  overflow-x: auto !important;
}

/* Blockquote */
blockquote {
  border-left: 4px solid $quote !important;
  padding-left: 16px !important;
  margin: 16px 0 !important;
  font-style: italic !important;
  color: $quoteText !important;
}

/* Media */
img {
  max-width: 100% !important;
  height: auto !important;
}

/* Hide junk */
.paywall, .subscription-banner, .premium-banner,
nav, header, .navbar,
#darkModeToggle, #openProblemModal,
.storage-notification-container,
.fixed.bottom-4.left-4,
p.text-green-500.text-sm > a,
div:has(> a[href*="/tag/"]) {
  display: none !important;
}
''';
  }

  static String _fontUrl(String family) =>
      'https://fonts.googleapis.com/css2?family=${family.replaceAll(' ', '+')}:wght@400;600;700&display=swap';
}
