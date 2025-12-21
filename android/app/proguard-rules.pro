# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# WebView
-keep class com.pichillilorenzo.flutter_inappwebview.** { *; }
-keep public class com.pichillilorenzo.flutter_inappwebview.InAppWebViewFlutterPlugin {
  public static void registerWith(io.flutter.plugin.common.PluginRegistry$Registrar);
}

# General
-dontwarn io.flutter.**
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
