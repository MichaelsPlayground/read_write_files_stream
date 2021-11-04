# read_write_files_stream

unter IOS / Podfile folgendes eintragen:

post_install do |installer|

installer.pods_project.targets.each do |target|

flutter_additional_ios_build_settings(target)

# 兼容 Flutter 2.5

target.build_configurations.each do |config|

#       config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'

      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'i386 arm64'

    end    

end

end



sehr interessant für den perfekt beschriebenen Ablauf und Schlüsselmanagement

https://ente.io/architecture/

https://github.com/ente-io/frame

darauf die Dateiverschlüsselung entnommen

genutzt wird: Libsodium Sodium.cryptoSecretstreamXchacha20poly1305 

mit einem 32 Byte langem Schlüssel und einem 24 Byte langen Nonce 

Eine 84 MB große Datei wird auf dem Samsung A51 in rd. 5 Sekunden verschlüsselt und in 4.4 Sekunden entschlüsselt

* LOG * Encrypting file of size 83583111

* LOG * Encryption time: 4972 (A51) bzw. 1670 (MacMini)

* LOG * Decrypting file of size 83583475

* LOG * Decryption time: 4373 (A51) bzw. 1507 (MacMini) 

Nächster Schritt: keyDerivation mit Argon2id

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
