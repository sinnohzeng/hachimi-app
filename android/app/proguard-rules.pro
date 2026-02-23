# ---
# ProGuard / R8 rules for Hachimi App
# ---

# ─── Firebase ───
-keep class com.google.firebase.** { *; }
-keepattributes *Annotation*
-keepattributes Signature

# ─── Flutter ───
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# ─── Dart FFI ───
-keep class dart.** { *; }

# ─── Google Play Core (referenced by Flutter deferred components) ───
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# ─── Shared libraries ───
-keepnames class * implements java.io.Serializable
