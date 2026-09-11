import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

// ============================================================
// RELEASE KEYSTORE CONFIGURATION
// ============================================================

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.finora.financialcalculatorhub"

    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.finora.financialcalculatorhub"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val keyAliasValue = keystoreProperties["keyAlias"] as String?
            val keyPasswordValue = keystoreProperties["keyPassword"] as String?
            val storeFileValue = keystoreProperties["storeFile"] as String?
            val storePasswordValue = keystoreProperties["storePassword"] as String?

            if (
                keyAliasValue != null &&
                keyPasswordValue != null &&
                storeFileValue != null &&
                storePasswordValue != null
            ) {
                keyAlias = keyAliasValue
                keyPassword = keyPasswordValue
                storeFile = file(storeFileValue)
                storePassword = storePasswordValue
            }
        }
    }


    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }

    // ============================================================
    // ANDROIDX WORKMANAGER COMPATIBILITY
    // ============================================================
    //
    // Google Mobile Ads 25.4.0 resolves WorkManager 2.7.0.
    // Force a newer WorkManager version for the release build.
    //
    // This addresses the WorkManager/Room startup crash seen
    // in the Google Play Internal Testing release.
    //

    configurations.all {
        resolutionStrategy {
            force("androidx.work:work-runtime:2.11.2")
        }
    }
}

dependencies {
    constraints {
        implementation("androidx.work:work-runtime:2.11.2") {
            because(
                "Use a newer WorkManager version with Google Mobile Ads " +
                        "to avoid WorkManager/Room startup compatibility issues"
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}