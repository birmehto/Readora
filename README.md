# 📖 Free Medium Reader

A powerful Flutter application that provides seamless access to Medium articles with an enhanced reading experience. Break free from paywalls and enjoy distraction-free reading with advanced features and beautiful UI.

## ✨ Features

### 🔥 Core Features
- **Paywall Bypass**: Read Medium articles without subscription limitations
- **Smart URL Detection**: Automatically detects and processes Medium URLs from clipboard
- **Multi-Domain Support**: Works with medium.com and custom publications
- **Offline Reading**: Cache articles for offline access
- **Reading History**: Keep track of your reading progress
- **Bookmarks**: Save articles for later reading

### 🎨 User Experience
- **Beautiful UI**: Modern, clean interface with Material Design 3
- **Dark/Light Theme**: Automatic theme switching based on system preferences
- **Responsive Design**: Optimized for all screen sizes using ScreenUtil
- **Smooth Animations**: Engaging transitions and micro-interactions with Lottie
- **Loading States**: Beautiful shimmer effects during content loading
- **Error Handling**: Graceful error states with retry mechanisms

### 📱 Advanced Features
- **Share Integration**: Share articles with friends using native sharing
- **Reading Time**: Estimated reading time calculation
- **Font Customization**: Adjustable font size and reading preferences
- **Search Functionality**: Search through your reading history
- **Categories**: Organize articles by topics and tags
- **Reading Statistics**: Track your reading habits and progress
- **Network Awareness**: Smart handling of connectivity changes

### 🔧 Technical Features
- **State Management**: Powered by GetX for reactive state management
- **Local Storage**: Persistent data with GetStorage
- **Network Layer**: Robust HTTP client with Dio and logging
- **Image Caching**: Optimized image loading with cached_network_image
- **Responsive UI**: Adaptive layouts for different screen sizes
- **Performance**: Optimized rendering and memory management

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.10.4)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/free-medium-reader.git
   cd free-medium-reader
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 📱 How to Use

### Basic Usage
1. **Copy Article URL**: Copy any Medium article link
2. **Open App**: Launch the Free Medium Reader
3. **Paste URL**: The app automatically detects clipboard content
4. **Read**: Enjoy the article in a clean, distraction-free format

### Advanced Features
- **Bookmark**: Tap the bookmark icon to save articles
- **Share**: Use the share button to send articles to friends
- **Settings**: Customize reading preferences in the settings menu
- **History**: Access your reading history from the main menu
- **Search**: Use the search feature to find specific articles

## 🌐 Supported Platforms

### Domains
- ✅ medium.com
- ✅ towardsdatascience.com
- ✅ hackernoon.com
- ✅ uxdesign.cc
- ✅ freecodecamp.org
- ✅ All Medium custom publications
- ✅ Medium subdomain publications

### Platforms
- 📱 Android (API 21+)
- 🍎 iOS (12.0+)
- 🌐 Web (Chrome, Firefox, Safari, Edge)
- 💻 macOS
- 🐧 Linux
- 🪟 Windows

## 🛠️ Tech Stack

### Core Dependencies
```yaml
# State Management & Architecture
get: ^4.7.3                    # State management and dependency injection
get_storage: ^2.1.1            # Local storage solution

# Networking & Data
dio: ^5.4.0                     # HTTP client
http: ^1.6.0                    # HTTP requests
connectivity_plus: ^5.0.2      # Network connectivity monitoring
pretty_dio_logger: ^1.3.1      # Network request logging

# UI & Design
flutter_screenutil: ^5.9.3     # Responsive design
cached_network_image: ^3.3.0   # Image caching and loading
shimmer: ^3.0.0                 # Loading animations
lottie: ^3.0.0                  # Vector animations
flutter_animate: ^4.5.0        # UI animations
gap: ^3.0.1                     # Spacing widgets

# Content Processing
html: ^0.15.6                   # HTML parsing
flutter_html: ^3.0.0           # HTML rendering
webview_flutter: ^4.13.0       # Web content display

# Utilities
url_launcher: ^6.3.2           # URL handling
share_plus: ^12.0.1             # Native sharing
intl: ^0.19.0                   # Internationalization
equatable: ^2.0.5               # Value equality
logger: ^2.0.2+1                # Logging utility
```

## 📁 Project Structure

```
lib/
├── core/               # Core functionality and shared resources
│   ├── constants/      # App-wide constants
│   ├── di/            # Dependency injection
│   ├── error/         # Error handling
│   ├── network/       # Network utilities
│   ├── routes/        # App routing
│   ├── theme/         # App theming
│   ├── usecase/       # Base use case
│   └── utils/         # Utility functions
├── features/          # Feature-based modules (Clean Architecture)
│   ├── article/       # Article reading feature
│   │   ├── data/      # Data layer (repositories, data sources, models)
│   │   ├── domain/    # Domain layer (entities, repositories, use cases)
│   │   └── presentation/ # Presentation layer (pages, widgets, controllers)
│   ├── history/       # Reading history feature
│   │   └── presentation/ # History controllers and widgets
│   ├── settings/      # App settings feature
│   │   └── presentation/ # Settings pages
│   └── theme/         # Theme management feature
│       └── presentation/ # Theme controller
├── widgets/           # Shared UI components
└── main.dart          # Application entry point
```

## 🎯 Roadmap

### Version 1.1.0
- [ ] User authentication and sync
- [ ] Article recommendations
- [ ] Reading streaks and achievements
- [ ] Export articles to PDF
- [ ] Voice reading (TTS)

### Version 1.2.0
- [ ] Multiple language support
- [ ] Article comments and notes
- [ ] Social features and sharing
- [ ] Advanced search filters
- [ ] Reading analytics dashboard

### Version 2.0.0
- [ ] AI-powered article summaries
- [ ] Personalized reading recommendations
- [ ] Cross-platform synchronization
- [ ] Premium features and subscriptions

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚖️ Legal Notice

This application is for educational and personal use only. Please respect content creators and consider supporting them through official channels. The developers are not responsible for any misuse of this application.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Medium for providing quality content
- Open source community for the excellent packages
- Contributors and users for their support

## 📞 Support

- 📧 Email: support@freemediumreader.com
- 🐛 Issues: [GitHub Issues](https://github.com/yourusername/free-medium-reader/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/yourusername/free-medium-reader/discussions)
- 📱 Follow us: [@FreeReader](https://twitter.com/freereader)

---

**Made with ❤️ by the Free Medium Reader Team**
