/**
* Cordova Jenkinsfile
*/
node('android') {
   stage 'Checkout'
	 checkout scm

	 stage 'Prepare'
	 cordova platform add android
	 cordova prepare

	 stage 'Build'
	 cordova build android
}
