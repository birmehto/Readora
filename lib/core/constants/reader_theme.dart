class ReaderTheme {
  static const String customCssId = 'custom-reader-style';

  static String getCss({
    required double fontSize,
    required bool isDarkMode,
    String fontFamily = 'Inter',
  }) {
    final fontUrl = _getGoogleFontUrl(fontFamily);
    final fallback = fontFamily == 'Merriweather' ? 'serif' : 'sans-serif';

    return '''
      @import url('$fontUrl');

      html {
        ${isDarkMode ? 'background-color: #1a1c1e !important;' : 'background-color: #fdfcff !important;'}
      }

      body {
        font-family: '$fontFamily', $fallback !important;
        font-size: ${fontSize}px !important;
        line-height: 1.6 !important;
        padding: 16px !important;
        max-width: 100% !important;
        box-sizing: border-box !important;
        overflow-wrap: break-word !important;
        ${isDarkMode ? '''
          background-color: #1a1c1e !important;
          color: #e2e2e6 !important;
        ''' : '''
          background-color: #fdfcff !important;
          color: #1a1c1e !important;
        '''}
      }

      /* Force inheritance for common text containers */
      div, p, span, li, blockquote, dt, dd {
        font-size: inherit !important;
        line-height: inherit !important;
        font-family: inherit !important;
        color: inherit !important;
      }

      /* Relative scaling for headers */
      h1 { font-size: 2.0em !important; }
      h2 { font-size: 1.5em !important; }
      h3 { font-size: 1.25em !important; }
      h4 { font-size: 1.1em !important; }
      h5, h6 { font-size: 1.0em !important; }

      /* Aggressive Theme Reset */
      body * {
        background-color: transparent !important;
        color: inherit !important;
        font-family: inherit !important;
        max-width: 100% !important;
        box-sizing: border-box !important;
      }

      /* Re-apply styles for specific elements that need distinction */
      a {
        color: ${isDarkMode ? '#aec6ff' : '#005cbb'} !important;
        text-decoration: none !important;
      }

      strong, b {
        font-weight: 700 !important;
        color: inherit !important;
      }
      
      em, i {
        font-style: italic !important;
      }

      h1, h2, h3, h4, h5, h6 {
        margin-top: 1.5em !important;
        margin-bottom: 0.5em !important;
        font-weight: 600 !important;
        line-height: 1.3 !important;
        color: inherit !important;
      }

      /* Code blocks need their own background */
      pre, code {
        background-color: ${isDarkMode ? '#2c2c2c' : '#f0f0f0'} !important;
        color: ${isDarkMode ? '#e0e0e0' : '#333'} !important;
        font-family: monospace !important;
        padding: 2px 4px !important;
        border-radius: 4px !important;
      }
      
      pre {
        padding: 12px !important;
        overflow-x: auto !important;
      }
      
      blockquote {
        border-left: 4px solid ${isDarkMode ? '#64b5f6' : '#005cbb'} !important;
        padding-left: 16px !important;
        margin: 16px 0 !important;
        font-style: italic !important;
        color: ${isDarkMode ? '#b0bec5' : '#546e7a'} !important;
      }
      
      /* Improve readability */
      img {
        max-width: 100% !important;
        height: auto !important;
      }
      
      /* Hide unnecessary elements */
      .paywall, .subscription-banner, .premium-banner, nav, header, .navbar,
      #darkModeToggle, #openProblemModal, .storage-notification-container,
      .fixed.bottom-4.left-4 {
        display: none !important;
        visibility: hidden !important;
        opacity: 0 !important;
        height: 0 !important;
        width: 0 !important;
        pointer-events: none !important;
      }
      
      /* Hide 'Go to the original' link */
      p.text-green-500.text-sm > a {
        display: none !important;
      }
      
      /* Hide tags at bottom */
      div:has(> a[href*="/tag/"]) {
        display: none !important;
      }
    ''';
  }

  static String _getGoogleFontUrl(String family) {
    final font = family.replaceAll(' ', '+');
    return 'https://fonts.googleapis.com/css2?family=$font:wght@400;600;700&display=swap';
  }
}
