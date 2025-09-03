# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Flutter embedding and Play Store integration
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# Google Play Core (for Flutter deferred components)
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Razorpay
-keep class com.razorpay.** { *; }
-keep interface com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Keep Razorpay CheckoutActivity
-keep class com.razorpay.CheckoutActivity { *; }
