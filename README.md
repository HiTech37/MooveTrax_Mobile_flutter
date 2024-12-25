------- Build apk file
flutter build apk --release --target-platform android-arm,android-arm64,android-x64

output: build/app/outputs/flutter-apk/

------- Build aab file for deploying into google store ------------

flutter build appbundle --release

output: build/app/outputs/bundle/release/app-release.aab

--------- Deployment for Google store-------------

Receive the upload_certicate.perm and my-release-key.jks


--------- Deployment for Apple store -------------

Deploy by using Xcode