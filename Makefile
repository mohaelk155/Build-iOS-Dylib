CC = clang
SDK = $(shell xcrun --sdk iphoneos --show-sdk-path)
CFLAGS = -arch arm64 -isysroot $(SDK) -miphoneos-version-min=9.0 -fvisibility=hidden -O3 -I.

SOURCES = APIClient_Twink.m AntiDebug.m EncryptedStrings.m
OBJ_FILES = $(SOURCES:.m=.o)

TARGET = libapiclient.dylib

all: $(TARGET)

$(TARGET): $(OBJ_FILES)
	$(CC) -arch arm64 -isysroot $(SDK) -dynamiclib \
	      -framework Foundation -framework UIKit \
	      -o $@ $^
	strip -S -x $@ || true
	@echo "=== COMPILACION COMPLETA ==="
	@file $@
	@ls -lah $@

%.o: %.m
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ_FILES) $(TARGET)