@echo off
echo =====================================
echo Checking SHA-1 Fingerprint
echo =====================================
echo.

echo Your google-services.json has SHA-1:
echo 25:99:69:2B:9E:2A:AB:CE:68:40:C1:5B:C7:E2:63:52:10:01:16:85
echo.

echo Checking your local debug keystore SHA-1...
echo.

cd /d "%USERPROFILE%\.android"
if exist debug.keystore (
    echo Found debug.keystore at %USERPROFILE%\.android
    echo.
    keytool -list -v -keystore debug.keystore -alias androiddebugkey -storepass android -keypass android 2>nul | findstr "SHA1"
) else (
    echo ERROR: debug.keystore not found at %USERPROFILE%\.android
    echo.
    echo Trying to generate SHA-1 from gradle...
    cd /d "%~dp0android"
    call gradlew signingReport
)

echo.
echo =====================================
echo IMPORTANT: 
echo If the SHA-1 values don't match, you need to:
echo 1. Copy YOUR SHA-1 from above
echo 2. Go to Firebase Console
echo 3. Add YOUR SHA-1 to the Android app
echo 4. Download new google-services.json
echo =====================================
pause