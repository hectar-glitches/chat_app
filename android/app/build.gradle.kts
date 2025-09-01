plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // Add the Google services Gradle plugin for Firebase
    id("com.google.gms.google-services")
}

// Load the key.properties file if it exists (for release signing)
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = org.gradle.internal.impldep.org.yaml.snakeyaml.Yaml()
val useSigningConfig = keystorePropertiesFile.exists()

android {
    namespace = "com.example.chat_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Change this to your application ID before release
        applicationId = "com.example.chat_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Enable multidex for large apps
        multiDexEnabled = true
    }

    signingConfigs {
        if (useSigningConfig) {
            val properties = java.util.Properties()
            properties.load(java.io.FileInputStream(keystorePropertiesFile))
            
            create("release") {
                keyAlias = properties.getProperty("keyAlias")
                keyPassword = properties.getProperty("keyPassword")
                storeFile = file(properties.getProperty("storeFile"))
                storePassword = properties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        release {
            // Enables code shrinking, obfuscation, and optimization
            isMinifyEnabled = true
            // Enables resource shrinking
            isShrinkResources = true
            // Use R8 for code optimization
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            
            if (useSigningConfig) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                // Fallback to debug signing if no release signing config
                signingConfig = signingConfigs.getByName("debug")
            }
        }
        
        debug {
            // Enable useful debug options here
            isDebuggable = true
            applicationIdSuffix = ".debug"
        }
    }
}

flutter {
    source = "../.."
}
