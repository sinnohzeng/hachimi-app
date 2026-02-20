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

# ─── llama_cpp_dart — JNI / FFI ───
-keep class com.example.llama_cpp_dart.** { *; }
-keepclassmembers class * {
    native <methods>;
}
-keep class * extends java.lang.foreign.** { *; }

# ─── Dart FFI ───
-keep class dart.** { *; }

# ─── Shared libraries ───
-keepnames class * implements java.io.Serializable
