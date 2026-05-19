# Release Notes - v1.1.0

## ✨ What's New in v1.1.0

- **🏛️ Clean Architecture & Feature-First Separation** — Restructured all modules into Domain, Data, and Presentation subdirectories to ensure maximum modularity and standard codebase cleanliness.
- **📱 Native Share Intent Integration** — Integrated the cross-platform `receive_sharing_intent` package and fully cleaned up the Android/iOS native files to standard defaults.
- **🛠️ Unsigned IPA Sideloading support** — Added automated build scripts to build and package unsigned `.ipa` files without requiring codesigning credentials, perfect for AltStore or sideloading!
- **⚡ Advanced Reading Features**:
  - **💾 Persistent Scroll Position** — Remembers and resumes reading coordinates upon page loads.
  - **🔄 Engine Auto-Failover** — Integrated three mirror bypass servers with automatic error redirection.
  - **📊 Active Reading Progress** — Displays real-time reading progress indicators.
