node('android') {

    stage('Checkout Source') {
        dir('workspace') {
            git "https://github.com/feedhenry/some-android-app"
        }
    }
    
    stage('Execute Gradle') {
        dir('workspace') {
            println(env.GRADLE_HOME)
            def gradleHome = env.GRADLE_HOME
            if (!gradleHome) {
                // GRADLE_HOME=/var/lib/jenkins/android-sdk-linux/tools/templates/gradle/wrapper
                println('GRADLE_HOME not set - please set it via Manage Jenkins -> Configure System -> Global properties -> Enviromental Variables - for the android node')
                return -1
            }
            def proc = ["/bin/sh", "-c", "${gradleHome}/gradlew --version"].execute()
            proc.waitFor()
            println "stdout: ${proc.in.text}"
            println "return code: ${ proc.exitValue()}"
            println "stderr: ${proc.err.text}"
            return proc.exitValue()
        }
    }

    stage('Archive') {
        dir('workspace') {
            archive archive 'app/build/outputs/apk/*.apk'
        }
    }
}