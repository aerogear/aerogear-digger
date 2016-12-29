#!/bin/sh

# generate_osx_slave_credentials generates the credentials entry for the
# OSX slave.
function generate_osx_slave_credentials() {
    # we don't need to encode the password in Jenkins format.
    # it should work like that!
    # see https://groups.google.com/forum/?utm_medium=email&utm_source=footer#!msg/jenkinsci-users/7__3FLgqPL0/asaepbVdAQAJ
    # encoding is actually complicated. see following for decoding: http://xn--thibaud-dya.fr/jenkins_credentials.html
    # we would need to do it the other way around and we need to do it in bash.
  echo "<com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
          <scope>GLOBAL</scope>
          <id>aerogear-digger-jenkins-osx-slave-credentials</id>
          <description></description>
          <username>${OSX_SLAVE_USERNAME}</username>
          <password>${OSX_SLAVE_PASSWORD}</password>
        </com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
       "
}