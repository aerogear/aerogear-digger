<?xml version='1.0' encoding='UTF-8'?>
<slave>
    <name>digger-ios</name>
    <description>This is the Jenkins OSX slave which runs outside of OpenShift.</description>
    <remoteFS>/opt/jenkins</remoteFS>
    <numExecutors>5</numExecutors>
    <mode>NORMAL</mode>
    <retentionStrategy class="hudson.slaves.RetentionStrategy$Always"/>
    <launcher class="hudson.plugins.sshslaves.SSHLauncher" plugin="ssh-slaves@1.12">
        <port>${OSX_SLAVE_PORT}</port>
        <host>${OSX_SLAVE_HOST}</host>
        <credentialsId>aerogear-digger-jenkins-osx-slave-credentials</credentialsId>
        <maxNumRetries>0</maxNumRetries>
        <retryWaitTime>0</retryWaitTime>
    </launcher>
    <label></label>
    <nodeProperties/>
</slave>
