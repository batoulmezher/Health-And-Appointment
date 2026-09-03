buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // ✅ أضف هذا السطر (classpath الخاص بـ Google Services)
        classpath("com.google.gms:google-services:4.4.0")
        // ... classpath الأخرى إن وجدت (مثل Kotlin Gradle Plugin)
    }
}

allprojects {
    
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}