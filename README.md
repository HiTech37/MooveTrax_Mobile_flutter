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

git clone ....

remove pubspec.lock

checking the version of deployment in pubsepc.yaml file.

for example: version: 1.1.2+32  -> update 1.1.2+32

brew install flutter

flutter pub get

flutter pub upgrade

open -a Simulator

flutter build ios --release

flutter run

open ios/Runner.xcworkspace

- In file menu of Xcode

product/archive

- click Validte app and then Distribute app after



