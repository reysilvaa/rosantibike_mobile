# Keep Play Core classes
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

# Keep Flutter classes
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.R { *; }

# Keep Firebase classes
-keep class com.google.firebase.** { *; }

# Keep any classes referenced by native code
-keepclassmembers class * {
    native <methods>;
}