#!/bin/sh
./gradlew clean
./gradlew assembleDebug
./gradlew assembleDebugAndroidTest
 Location=eval echo "User Location is" + "~$USER"
 echo "Location is....."+ $USER

function getUserId(){
#Check whether device is connected
numberOfDevices=$(adb devices)
declare -r startDeviceIdIndex=24
isDeviceConnected=${numberOfDevices:$startDeviceIdIndex}
echo "isDeviceConnected" $isDeviceConnected

if [ -z "$isDeviceConnected" ]
then
  echo "Device not found"
  exit
fi
#Install app-debug Test Apk and  Normal app-debug Apk in device.
  userWorkingdDir=$(pwd)
  echo "User Working Directory is:-"$userWorkingdDir
  debugTestApk=$userWorkingdDir/ShellScriptDemoForInstrumentation/app/build/outputs/apk/androidTest/debug/app-debug-androidTest.apk
  echo "Test Apk " + $debugTestApk
  appDebugNormalApk=$userWorkingdDir/workspace/ShellScriptDemoForInstrumentation/app/build/outputs/apk/debug/app-debug.apk
  echo "Normal Apk" + $appDebugNormalApk
  echo "Installing app-debug Application....." $(adb install $appDebugNormalApk)
  echo "Installing app-debug-androidTest Test Application....." $(adb install $debugTestApk)
#Find list of active users on Device
activeUsersOnDevice=$(adb shell pm list users)
echo "Active Users Details:" $(adb shell pm list users)
delimiter="UserInfo{"
numberOfActiveUsersOnDevice=$(echo "$activeUsersOnDevice" | tr " " "\n" | grep -c "$delimiter")
echo "Active User count on Device" $numberOfActiveUsersOnDevice

declare -r thresholdForTwoActiveUser=2
declare -r thresholdForOneActiveUser=1
declare -r startIndex=0
declare userInfo;
declare lengthOfUserId;

#Get user info of primary user or secondary user based on user count on device.
if [ $numberOfActiveUsersOnDevice == $thresholdForTwoActiveUser ]
then
  userInfo=${activeUsersOnDevice##*$delimiter}
  lengthOfUserId=2
elif [ $numberOfActiveUsersOnDevice == $thresholdForOneActiveUser ]
then
  userInfo=${activeUsersOnDevice##*$delimiter}
  lengthOfUserId=1
else
  echo "Irrelevant number of active users on device"
  exit
fi

echo "User Info:" $userInfo

#Find user id from User Info
userId=${userInfo:$startIndex:$lengthOfUserId}
echo "UserId is:" $userId
}
getUserId

#Install apk in device


#Below adb statement worked on Jenkins
#adb shell am instrument -w -r    -e debug false -e class 'com.example.demojankinsshellscript.ExampleInstrumentedTest' com.example.demojankinsshellscript.test/androidx.test.runner.AndroidJUnitRunner
#This is also working
echo $(adb shell am instrument --user $userId -w -r -e debug false -e class 'com.example.demojankinsshellscript.ExampleInstrumentedTest' com.example.demojankinsshellscript.test/androidx.test.runner.AndroidJUnitRunner)
#END
