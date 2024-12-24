# Preserve all classes and members in the com.moovetrax.app package
-keep class com.moovetrax.app.** { *; }
-keepclassmembers class com.moovetrax.app.** { *; }

# Preserve all classes and members in the io.flutter package (required for Flutter)
-keep class io.flutter.** { *; }
-keepclassmembers class io.flutter.** { *; }

# Preserve all classes and members in the android and androidx packages (necessary for Android components)
-keep class android.** { *; }
-keep class androidx.** { *; }

# Preserve public constructors of all classes extending Activity (needed for Android lifecycle management)
-keep public class * extends android.app.Activity {
    public <init>(...);
}

# Preserve public constructors of all classes extending Service (needed for Android services)
-keep public class * extends android.app.Service {
    public <init>(...);
}

# Preserve public constructors of all classes extending BroadcastReceiver (needed for broadcast receivers)
-keep public class * extends android.content.BroadcastReceiver {
    public <init>(...);
}

# Preserve public constructors of all classes extending ContentProvider (needed for content providers)
-keep public class * extends android.content.ContentProvider {
    public <init>(...);
}

# Preserve public constructors of all classes extending Application (needed for Android applications)
-keep public class * extends android.app.Application {
    public <init>(...);
}

# Preserve Flutter-specific classes that are often used in plugins
-keep class io.flutter.plugin.** { *; }
-keepclassmembers class io.flutter.plugin.** { *; }

# Preserve Gson annotations (if you are using Gson for JSON serialization)
-keepattributes *Annotation*

# Preserve method and field names for JSON parsing libraries
-keep class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    private void readObjectNoData();
}

# If using Retrofit or other reflection-based libraries, preserve class and method names
-keepclassmembers class ** {
    @retrofit2.http.* <methods>;
}

# Preserve the R class to avoid issues with resources
-keep class **.R$* {
    *;
}

# Optional: If you have external libraries, add rules to preserve them
# Example: If using a third-party library like Glide, add rules to preserve its classes
-keep class com.bumptech.glide.** { *; }

# If you're using custom ProGuard rules for third-party libraries, include them here
# Example: Including ProGuard rules for OkHttp
# -keep class okhttp3.** { *; }

# Retain enumerations to ensure proper usage of enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Retain annotations for libraries that depend on reflection
-keepattributes *Annotation*

# Preserve lambda expressions and method references
-keep class * {
    public static final * lambda$*(...);
}

# Prevent removal of Google Play Core classes
-keep class com.google.android.play.** { *; }
-dontwarn com.google.android.play.**

# Keep Flutter deferred component-related classes
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }