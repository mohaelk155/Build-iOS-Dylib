#!/bin/bash
echo "Compilando dylib para iOS..."

# Buscar el SDK de iOS más reciente
IOS_SDK=$(xcrun --sdk iphoneos --show-sdk-path)

clang -dynamiclib \
  -arch arm64 \
  -isysroot $IOS_SDK \
  -miphoneos-version-min=9.0 \
  -fvisibility=hidden \
  -fblocks \
  -framework Foundation \
  -framework UIKit \
  -framework Security \
  -O3 \
  -o libprotected.dylib \
  CryptoEngine.m \
  AntiDebug.m \
  EncryptedStrings.m \
  FIXToast.m \
  APIClient_Twink.m \
  Constructor.m