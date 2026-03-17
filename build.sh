#!/bin/bash
echo "Compilando dylib con proteccion..."
clang -dynamiclib \
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
EOF
