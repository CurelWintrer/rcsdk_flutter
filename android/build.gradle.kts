import kotlin.math.sin

group = "world.crossocean.rcsdk_flutter"
version = "1.0-SNAPSHOT"

// `rcsdk` is shipped with this plugin rather than published to a remote Maven
// repository.  Dependency resolution happens in the consuming app project, so
// registering this repository only on the plugin project is not sufficient.
val rcsdkLocalMavenRepository = layout.projectDirectory.dir("local-maven")

buildscript {
    val kotlinVersion = "2.3.20"
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:9.0.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
    }
}

// A Flutter plugin is added as a Gradle subproject of the host app.  Add the
// bundled Maven repository to every host project so that the app can resolve
// this plugin's transitive `com.skydroid:rcsdk` dependency.
rootProject.allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            url = rcsdkLocalMavenRepository.asFile.toURI()
        }
    }
}

plugins {
    id("com.android.library")
}

android {
    namespace = "world.crossocean.rcsdk_flutter"

    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/kotlin")
        }
        getByName("test") {
            java.srcDirs("src/test/kotlin")
        }
    }

    defaultConfig {
        minSdk = 24
    }

    testOptions {
        unitTests {
            isIncludeAndroidResources = true
            all {
                it.useJUnitPlatform()

                it.outputs.upToDateWhen { false }

                it.testLogging {
                    events("passed", "skipped", "failed", "standardOut", "standardError")
                    showStandardStreams = true
                }
            }
        }
    }

    defaultConfig {
        consumerProguardFiles("consumer-rules.pro")
    }

}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}



dependencies {
    testImplementation("org.jetbrains.kotlin:kotlin-test")
    testImplementation("org.mockito:mockito-core:5.0.0")
    implementation("com.skydroid:rcsdk:1.9.2")
    implementation("commons-net:commons-net:3.12.0")
}


