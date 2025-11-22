plugins {
    id("com.android.application")
    id("kotlin-android")
    id("kotlin-kapt")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

fun Any.safeGetVersionProperty(name: String): Any? {
    val klass = this::class.java
    runCatching {
        return klass.getMethod(name).invoke(this)
    }
    runCatching {
        val getterName = "get" + name.capitalize()
        return klass.getMethod(getterName).invoke(this)
    }
    runCatching {
        return klass.getField(name).get(this)
    }
    return null
}

val packageName = "com.fluttercandies.wechatAssetsPickerExample"

android {
    namespace = packageName
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = packageName
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.safeGetVersionProperty("versionCode") as Int?
        versionName = flutter.safeGetVersionProperty("versionName") as String?
    }

    compileOptions {
        // Sets Java compatibility to Java 17
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/kotlin")
        }
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    packaging {
        dex {
            useLegacyPackaging = true
        }
        jniLibs {
            useLegacyPackaging = true
        }
    }

    signingConfigs {
        create("forAll") {
            storeFile = file("${rootDir.absolutePath}/key.jks")
            storePassword = "picker"
            keyAlias = "picker"
            keyPassword = "picker"
            enableV1Signing = true
            enableV2Signing = true
            enableV3Signing = true
            enableV4Signing = true
        }
    }

    buildTypes {
        getByName("debug") {
            signingConfig = signingConfigs.getByName("forAll")
        }
        getByName("profile") {
            signingConfig = signingConfigs.getByName("forAll")
        }
        getByName("release") {
            signingConfig = signingConfigs.getByName("forAll")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.github.bumptech.glide:glide:4.15.0")
    kapt("com.github.bumptech.glide:compiler:4.15.0")
}
