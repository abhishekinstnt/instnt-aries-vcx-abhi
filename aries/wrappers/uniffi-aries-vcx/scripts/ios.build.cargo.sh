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
        
        mkdir ${IOS_APP_DIR}/Source

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

        zip -r ${ABI_PATH}/vcx.xcframework.zip ${ABI_PATH}/vcx.xcframework

        # Remove .a file if it is not required and have large size
        rm -R ${ABI_PATH}/libuniffi_vcx.a
        rm -R ${ABI_PATH}/vcx.xcframework

    }

    release_xcframework() {

        export UNIFFI_ROOT="${ARIES_VCX_ROOT}/aries/wrappers/uniffi-aries-vcx"
        export IOS_APP_DIR="${ARIES_VCX_ROOT}/aries/agents/ios/ariesvcx/ariesvcx"
        export ABI_PATH=${IOS_APP_DIR}/Frameworks

        # Replace these with your actual values
        #GITHUB_TOKEN=${{ secrets.GITHUB_TOKEN }}
        #REPO=${{ github.repository }}
        #TAG=${{ github.ref_name }}
        
        # Create a release
        RESPONSE=$(curl -s -X POST \
            -H "Authorization: token $GITHUB_TOKEN" \
            -H "Accept: application/vnd.github.v3+json" \
            -d "{\"tag_name\":\"$TAG\",\"name\":\"Release $TAG\",\"draft\":false,\"prerelease\":false}" \
            https://api.github.com/repos/$REPO/releases)
        
        # Extract the release ID
        RELEASE_ID=$(echo $RESPONSE | jq -r .id)
        echo "Release ID: $RELEASE_ID"
        echo "RELEASE_ID=$RELEASE_ID" >> $GITHUB_ENV

        # Replace with the path to your xcframework file
        chmod +x ${ARIES_VCX_ROOT}/vcxAPI.swift.zip
        XCFRAMEWORK_PATH= "${ARIES_VCX_ROOT}/vcxAPI.swift.zip"
        #${ABI_PATH}/vcx.xcframework.zip
        
            # Upload the file to the release
            curl -s -X POST \
            -H "Authorization: token ${{ secrets.GITHUB_TOKEN }}" \
            -H "Content-Type: application/zip" \
            --data-binary @"$XCFRAMEWORK_PATH" \
            "https://uploads.github.com/repos/${{ github.repository }}/releases/$RELEASE_ID/assets?name=$(basename $XCFRAMEWORK_PATH)"

    }

    #generate_bindings
    #build_uniffi_for_demo
    #build_ios_xcframework
    release_xcframework
