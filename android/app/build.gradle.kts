// 1. IMPORTAÇÕES NECESSÁRIAS PARA LER O ARQUIVO (A CORREÇÃO ESTÁ AQUI)
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// 2. LENDO A CHAVE DO JEITO "KOTLIN"
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.reader().use { reader ->
        keystoreProperties.load(reader)
    }
}

android {
    namespace = "com.catequese.sjoc"
    
    compileSdk = 36 
    
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    // 3. AVISO DO DEPRECATED CORRIGIDO (Deixando mais simples)
    kotlinOptions {
        jvmTarget = "17"
    }
    
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            val storeFilePath = keystoreProperties.getProperty("storeFile")
            if (storeFilePath != null) {
                storeFile = file(storeFilePath)
            }
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    defaultConfig {
        applicationId = "com.catequese.sjoc.app"
        
        minSdk = flutter.minSdkVersion 
        targetSdk = 36 
        
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false 
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
