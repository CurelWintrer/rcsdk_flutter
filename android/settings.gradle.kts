rootProject.name = "rcsdk_flutter"


dependencyResolutionManagement {
    repositoriesMode.set(
        RepositoriesMode.PREFER_PROJECT
    )

    repositories {
        google()
        mavenCentral()

        // RC SDK 本地 Maven 仓库
        maven {
            url = uri("${rootDir}/local-maven")
        }
    }
}
