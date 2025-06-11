SCRIPT_DIR=$(dirname "$(realpath "$0")")
cd "$SCRIPT_DIR"
mkdir -p build

cmake \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  -DCMAKE_OSX_SYSROOT=iphoneos \
  -DCMAKE_OSX_DEPLOYMENT_TARGET=12.0 \
  -B build/build_ios_device \
  -G Xcode \
  .
xcodebuild 'BUILD_LIBRARY_FOR_DISTRIBUTION=YES' -scheme capnp-rpc -project build/build_ios_device/Cap\'n\ Proto\ Root.xcodeproj

cmake \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  -DCMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LANGUAGE_STANDARD=c++17 \
  -DCMAKE_OSX_SYSROOT=iphonesimulator \
  -DCMAKE_OSX_DEPLOYMENT_TARGET=12.0 \
  -B build/build_ios_simulator \
  -G Xcode \
  .
xcodebuild 'BUILD_LIBRARY_FOR_DISTRIBUTION=YES' -scheme capnp-rpc -project build/build_ios_simulator/Cap\'n\ Proto\ Root.xcodeproj

if [ -d "build/xcframework" ]; then
  rm -rf build/xcframework
fi
mkdir -p build/xcframework
FILE_PATH_DEVICE=$(find build/build_ios_device -type f -name "libcapnp-rpc.a" -print -quit)
FILE_PATH_SIMULATOR=$(find build/build_ios_simulator -type f -name "libcapnp-rpc.a" -print -quit)
xcodebuild -create-xcframework -library $FILE_PATH_DEVICE -library $FILE_PATH_SIMULATOR -output build/xcframework/libcapnp-rpc.a.xcframework

FILE_PATH_DEVICE=$(find build/build_ios_device -type f -name "libcapnp.a" -print -quit)
FILE_PATH_SIMULATOR=$(find build/build_ios_simulator -type f -name "libcapnp.a" -print -quit)
xcodebuild -create-xcframework -library $FILE_PATH_DEVICE -library $FILE_PATH_SIMULATOR -output build/xcframework/libcapnp.a.xcframework

FILE_PATH_DEVICE=$(find build/build_ios_device -type f -name "libkj-async.a" -print -quit)
FILE_PATH_SIMULATOR=$(find build/build_ios_simulator -type f -name "libkj-async.a" -print -quit)
xcodebuild -create-xcframework -library $FILE_PATH_DEVICE -library $FILE_PATH_SIMULATOR -output build/xcframework/libkj-async.a.xcframework

FILE_PATH_DEVICE=$(find build/build_ios_device -type f -name "libkj.a" -print -quit)
FILE_PATH_SIMULATOR=$(find build/build_ios_simulator -type f -name "libkj.a" -print -quit)
xcodebuild -create-xcframework -library $FILE_PATH_DEVICE -library $FILE_PATH_SIMULATOR -output build/xcframework/libkj.a.xcframework
