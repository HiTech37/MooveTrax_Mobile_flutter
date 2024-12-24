keytool -genkey -v -keystore zeljko-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias zeljko-relaeas-key

keystore Password: moovetrax

flutter build apk --release --target-platform android-arm,android-arm64,android-x64