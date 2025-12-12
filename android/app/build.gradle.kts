plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter plugin phải đặt cuối
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.student_timetable_app"
    compileSdk = 35
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Bật desugaring
        isCoreLibraryDesugaringEnabled = true

        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.student_timetable_app"
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // Bổ sung bắt buộc khi bật coreLibraryDesugaringEnabled
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
}

flutter {
    source = "../.."
}
