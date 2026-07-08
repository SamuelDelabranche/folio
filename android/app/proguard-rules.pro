# Flutter embedding
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

# Google Play Core (référencé par Flutter pour les deferred components, non utilisé)
-dontwarn com.google.android.play.core.**
