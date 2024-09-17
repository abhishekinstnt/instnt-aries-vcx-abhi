    #!/bin/bash
    set -ex

    SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

    # Required env vars
    ARIES_VCX_ROOT=$(dirname $(dirname $(dirname $(dirname $SCRIPT_DIR))))
    IOS_BUILD_DEPS_DIR=${ARIES_VCX_ROOT}/target/ios_build_deps
    LANGUAGE="swift"
    TARGET="aarch64-apple-ios"
    TARGET_NICKNAME="arm64"
    ABI="iphoneos"

    generate_bindings() {

        #export LIBZMQ_LIB_DIR=/usr/lib/x86_64-linux-gnu
        #export LIBZMQ_INCLUDE_DIR=/usr/include

        # # Update package list
        # sudo apt-get update

        # # Install necessary packages
        # sudo apt-get install cmake autoconf automake libtool pkg-config git

        # # Clone ZeroMQ repository
        # git clone https://github.com/zeromq/libzmq.git vendor/libzmq

        # # Build ZeroMQ from source
        # cd vendor/libzmq
        # ./autogen.sh
        # ./configure
        # make
        # # Optional: Install ZeroMQ
        # sudo make install
        
        export UNIFFI_ROOT="${ARIES_VCX_ROOT}/aries/wrappers/uniffi-aries-vcx"
        export IOS_APP_DIR="${ARIES_VCX_ROOT}/aries/agents/ios/ariesvcx/ariesvcx"
        
        rustup target add ${TARGET}

        cargo install cargo-lipo

        pushd "${UNIFFI_ROOT}/core"
            cargo run --features=uniffi/cli --bin uniffi-bindgen generate src/vcx.udl --language ${LANGUAGE}
        popd
        
        #mkdir ${IOS_APP_DIR}/Source

        cp -R ${UNIFFI_ROOT}/core/src/vcx.swift ${UNIFFI_ROOT}/core/src/vcxFFI.* ${IOS_APP_DIR}
        cp -R ${UNIFFI_ROOT}/core/src/vcx.swift ${UNIFFI_ROOT}/core/src/vcxFFI.* ${IOS_APP_DIR}/Source
        rm -R ${UNIFFI_ROOT}/core/src/vcx.swift ${UNIFFI_ROOT}/core/src/vcxFFI.*
    }

    build_uniffi_for_demo() {
        echo "Running build_uniffi_for_demo..."
        export UNIFFI_ROOT="${ARIES_VCX_ROOT}/aries/wrappers/uniffi-aries-vcx"
        export IOS_APP_DIR="${ARIES_VCX_ROOT}/aries/agents/ios/ariesvcx/ariesvcx"
        export ABI_PATH=${IOS_APP_DIR}/Frameworks
        mkdir -p ${ABI_PATH}

        pushd ${UNIFFI_ROOT}/core
            cargo build --target ${TARGET} --features "aries_vcx_anoncreds/zmq_vendored"
            cp ${ARIES_VCX_ROOT}/target/${TARGET}/debug/libuniffi_vcx.a ${ABI_PATH}/libuniffi_vcx.a

        popd
    }

    build_ios_xcframework() {

        export UNIFFI_ROOT="${ARIES_VCX_ROOT}/aries/wrappers/uniffi-aries-vcx"
        export IOS_APP_DIR="${ARIES_VCX_ROOT}/aries/agents/ios/ariesvcx/ariesvcx"
        export ABI_PATH=${IOS_APP_DIR}/Frameworks

        #mv ${UNIFFI_ROOT}/core/src/vcxFFI.modulemap ${UNIFFI_ROOT}/core/src/module.modulemap 

        xcodebuild -create-xcframework -library ${ABI_PATH}/libuniffi_vcx.a -headers ${IOS_APP_DIR}/Source -output "${ABI_PATH}/vcx.xcframework"

        #zip -r ${ABI_PATH}/vcx.xcframework.zip ${ABI_PATH}/vcx.xcframework

        cd ${ABI_PATH}
        zip -r vcx.xcframework.zip vcx.xcframework

        # Remove .a file if it is not required and have large size
        rm -R ${ABI_PATH}/libuniffi_vcx.a
        rm -R ${ABI_PATH}/vcx.xcframework

    }

    release_xcframework_backup() {

        export UNIFFI_ROOT="${ARIES_VCX_ROOT}/aries/wrappers/uniffi-aries-vcx"
        export IOS_APP_DIR="${ARIES_VCX_ROOT}/aries/agents/ios/ariesvcx/ariesvcx"
        export ABI_PATH=${IOS_APP_DIR}/Frameworks

        XCFRAMEWORK_PATH="${ABI_PATH}/vcx.xcframework.zip"

        # Print for debugging
        echo "XCFRAMEWORK_PATH=${XCFRAMEWORK_PATH}"

        # Ensure the file has the correct permissions (readable)
        chmod u+rw "$XCFRAMEWORK_PATH"

        # Get the name of the file to be uploaded
        ASSET_NAME=$(basename "$XCFRAMEWORK_PATH")

        # Fetch the list of assets for the release
        ASSET_URL="https://api.github.com/repos/$REPO/releases/$TAG/assets"
        ASSETS_JSON=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "$ASSET_URL")

        # Extract asset ID(s) of the existing asset with the same name
        ASSET_IDS=$(echo "$ASSETS_JSON" | jq -r ".[] | select(.name == \"$ASSET_NAME\") | .id")

        # Delete the existing asset(s)
        for ASSET_ID in $ASSET_IDS; do
        echo "Deleting existing asset with ID: $ASSET_ID"
        curl -s -X DELETE -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/$REPO/releases/assets/$ASSET_ID"
        done

        # Upload the file to the release
        # curl -s -X POST \
        # -H "Authorization: token $GITHUB_TOKEN" \
        # -H "Content-Type: application/zip" \
        # --data-binary @"$XCFRAMEWORK_PATH" \
        # "https://uploads.github.com/repos/$REPO/releases/$RELEASE_ID/assets?name=$(basename "$XCFRAMEWORK_PATH")"

        RESPONSE=$(curl -s -X POST \
            -H "Authorization: token $GITHUB_TOKEN" \
            -H "Accept: application/vnd.github.v3+json" \
            -d "{\"tag_name\":\"$TAG\",\"name\":\"Release $TAG\",\"draft\":false,\"prerelease\":false}" \
            https://api.github.com/repos/$REPO/releases)

        rm -R ${ABI_PATH}/vcx.xcframework.zip

        echo "File uploaded"

    }

    delete_existing_xcframework() {
        
        export UNIFFI_ROOT="${ARIES_VCX_ROOT}/aries/wrappers/uniffi-aries-vcx"
        export IOS_APP_DIR="${ARIES_VCX_ROOT}/aries/agents/ios/ariesvcx/ariesvcx"
        export ABI_PATH=${IOS_APP_DIR}/Frameworks

        XCFRAMEWORK_PATH="${ABI_PATH}/vcx.xcframework.zip"

        # Print for debugging
        echo "XCFRAMEWORK_PATH=${XCFRAMEWORK_PATH}"

        # Ensure the file has the correct permissions (readable)
        chmod u+rw "$XCFRAMEWORK_PATH"

        # Get the name of the file to be uploaded
        ASSET_NAME=$(basename "$XCFRAMEWORK_PATH")

        # Fetch the release ID by tag
        RELEASE_ID=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/$REPO/releases/tags/$TAG" | jq -r '.id')

        if [ "$RELEASE_ID" == "null" ]; then
        echo "Release not found for tag: $TAG"
        else
        echo "Found release ID: $RELEASE_ID"

        # Delete the release
        echo "Deleting release with ID: $RELEASE_ID"
        RES=$(curl -s -X DELETE -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/$REPO/releases/$RELEASE_ID")
        echo "Release deletion complete."
        fi

        echo "Asset delete process complete."

    }

    upload_framework() {

        export UNIFFI_ROOT="${ARIES_VCX_ROOT}/aries/wrappers/uniffi-aries-vcx"
        export IOS_APP_DIR="${ARIES_VCX_ROOT}/aries/agents/ios/ariesvcx/ariesvcx"
        export ABI_PATH=${IOS_APP_DIR}/Frameworks

        # Create a release
        
        RESPONSE=$(curl -s -X POST \
            -H "Authorization: token $GITHUB_TOKEN" \
            -H "Accept: application/vnd.github.v3+json" \
            -d "{\"tag_name\":\"$TAG\",\"name\":\"Release $TAG\",\"draft\":false,\"prerelease\":false}" \
            https://api.github.com/repos/$REPO/releases)
        
        #Extract the release ID
        RELEASE_ID=$(echo $RESPONSE | jq -r .id)
        echo "Release ID: $RELEASE_ID"
        echo "RELEASE_ID=$RELEASE_ID" >> $GITHUB_ENV

        # Define the path to your zip file
        XCFRAMEWORK_PATH="${ABI_PATH}/vcx.xcframework.zip"

        # Print for debugging
        echo "XCFRAMEWORK_PATH=${XCFRAMEWORK_PATH}"

        # Ensure the file has the correct permissions (readable)
        chmod u+rw "$XCFRAMEWORK_PATH"

        # Get the name of the file to be uploaded
        ASSET_NAME=$(basename "$XCFRAMEWORK_PATH")

        # Upload the file to the release
        curl -s -X POST \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Content-Type: application/zip" \
        --data-binary @"$XCFRAMEWORK_PATH" \
        "https://uploads.github.com/repos/$REPO/releases/$RELEASE_ID/assets?name=$(basename "$XCFRAMEWORK_PATH")"

        rm -R ${ABI_PATH}/vcx.xcframework.zip

        echo "File uploaded"

    }

    checksum() {
        

set -e

# Variables
URL="https://github.com/instnt-inc/instnt-aries-vcx/releases/download/abhishek_GithubAction2/vcx.xcframework.zip"  # Replace with your URL
FILE_NAME="vcx.xcframework.zip"  # Name of the downloaded file

# Function to display usage information
usage() {
    echo "Usage: $0 -u <url> -f <file_name>"
    exit 1
}

# Parse command-line arguments
while getopts "u:f:" opt; do
    case ${opt} in
        u )
            URL=$OPTARG
            ;;
        f )
            FILE_NAME=$OPTARG
            ;;
        * )
            usage
            ;;
    esac
done
shift $((OPTIND -1))

# Check if URL and FILE_NAME are provided
if [ -z "$URL" ] || [ -z "$FILE_NAME" ]; then
    usage
fi

# Download the file
echo "Downloading file from $URL..."
curl -O "$URL"

# Verify if the file was downloaded successfully
if [ ! -f "$FILE_NAME" ]; then
    echo "Error: File $FILE_NAME not found after download."
    exit 1
fi

# Compute the SHA-256 checksum
CHECKSUM=$(shasum -a 256 "$FILE_NAME" | awk '{ print $1 }')

# Output the checksum
echo "Checksum for $FILE_NAME: $CHECKSUM"
    }

    # generate_bindings
    # build_uniffi_for_demo
    # build_ios_xcframework
    # delete_existing_xcframework
    # upload_framework

    checksum