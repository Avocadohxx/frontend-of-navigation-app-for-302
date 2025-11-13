plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.version4"
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
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.version4"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") { // 只保留 release 配置
            // 发布版本的签名配置
            storeFile = file("../amap.jks") // 确保路径用双引号包围
            keyAlias = "amap"
            storePassword = "android"
            keyPassword = "android"
        }
        // 移除下面这部分 create("debug") { ... }
        // create("debug") { // 调试版本的签名配置
        //     storeFile = file("../amap.jks") // 系统默认 debug keystore 更安全
        //     keyAlias = "amap"
        //     storePassword = "android"
        //     keyPassword = "android"
        // }
    }

    buildTypes {
        getByName("release") {
            // 使用您自定义的 release 签名配置
            signingConfig = signingConfigs.getByName("release")
        }
        getByName("debug") {
            // 使用系统默认的 debug 签名配置，通常不需要显式设置
            // signingConfig = signingConfigs.getByName("debug") // 这行可以注释掉或删除
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.amap.api:location:5.2.0")
    implementation("com.amap.api:3dmap:8.1.0")
    implementation("com.amap.api:search:5.0.0")
    // 使用标准库依赖，让插件管理版本
    implementation("org.jetbrains.kotlin:kotlin-stdlib")
}