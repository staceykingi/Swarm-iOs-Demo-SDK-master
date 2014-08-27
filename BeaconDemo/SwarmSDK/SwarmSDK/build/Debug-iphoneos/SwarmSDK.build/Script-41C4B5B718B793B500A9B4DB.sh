#!/bin/sh
LIB_TARGET_NAME="SwarmSDK"

if [ "${ACTION}" = "clean" ]
then
echo "Cleaning Libraries..."
cd "${PROJECT_DIR}"
xcodebuild -target "$LIB_TARGET_NAME" -configuration ${CONFIGURATION} -sdk iphoneos clean
xcodebuild -target "$LIB_TARGET_NAME" -configuration ${CONFIGURATION} -sdk iphonesimulator clean
fi

if [ "${ACTION}" = "build" ]
then
echo "Building Libraries"
cd "${PROJECT_DIR}"
xcodebuild -target "$LIB_TARGET_NAME" -configuration ${CONFIGURATION} -sdk iphoneos
xcodebuild -target "$LIB_TARGET_NAME" -configuration ${CONFIGURATION} -sdk iphonesimulator

# Check that this is what your static libraries are called
ARM_FILES="${PROJECT_DIR}/build/${CONFIGURATION}-iphoneos/lib${LIB_TARGET_NAME}.a"
I386_FILES="${PROJECT_DIR}/build/${CONFIGURATION}-iphonesimulator/lib${LIB_TARGET_NAME}.a"

mkdir -p "${PROJECT_DIR}/build/Universal"

echo "Creating library..."
lipo -create "$ARM_FILES" "$I386_FILES" -o "${PROJECT_DIR}/build/Universal/lib${PRODUCT_NAME}.a"
fi
