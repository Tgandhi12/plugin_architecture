#!/bin/bash

set -e

cd "$(dirname "$0")"

echo "=========================================="
echo "Plugin Host - GraalVM Native Build and Run"
echo "=========================================="
echo

if ! command -v java >/dev/null 2>&1; then
echo "ERROR: Java not found in PATH."
exit 1
fi

if ! command -v native-image >/dev/null 2>&1; then
echo "ERROR: GraalVM native-image not found."
exit 1
fi

echo "Building Native Image..."
echo

./gradlew clean nativeCompile

echo

EXECUTABLE=$(find build/native/nativeCompile -type f -perm -111 | head -n 1)

if [ -z "$EXECUTABLE" ]; then
echo "ERROR: Native executable not found."
exit 1
fi

echo
echo "Running Native Executable..."
echo

"$EXECUTABLE"

echo
echo "=========================================="
echo "Execution Completed Successfully"
echo "=========================================="
