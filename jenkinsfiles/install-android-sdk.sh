set -x

BASE_DIR=/opt/tools
ANDROID_SDK_DIR=/android-sdk-linux

if [ -d "${BASE_DIR}/${ANDROID_SDK_DIR}" ]
then
  echo 'Android SDK installed continueing normally'
else
  echo 'Installing Android SDK'
  cd ${BASE_DIR}
  wget --output-document=android-sdk.tgz --quiet https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
  tar xzf android-sdk.tgz 
  rm -f android-sdk.tg
  
  ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android-sdk-linux/tools/android update sdk --all --no-ui --filter platform-tools,tools
  ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android-sdk-linux/tools/android update sdk --all --no-ui --filter platform-tools,tools,build-tools-25.0.0,android-25,addon-google_apis_x86-google-21,extra-android-support,extra-google-google_play_services,sys-img-armeabi-v7a-android-24

  # Setup environment
  export ANDROID_HOME=${BASE_DIR}/${ANDROID_SDK_DIR}
  export PATH=${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

  android list target
fi