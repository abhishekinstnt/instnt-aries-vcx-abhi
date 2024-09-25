// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InstntAriesVCX",
    products: [
        .library(
            name: "InstntAriesVCX",
            targets: ["InstntAriesVCX"]),
    ],
    targets: [
        .target(
            name: "InstntAriesVCX",
            // dependencies: ["VCX_uniffiFFI_Lib"],
            path: "aries/agents/ios/ariesvcx/ariesvcx/Source/"
            ),
        // .binaryTarget(
        //     name: "VCX_uniffiFFI_Lib",
        //     url: "https://github.com/instnt-inc/instnt-aries-vcx/releases/download/abhishek_GithubAction2/vcx.xcframework.zip",
        //     checksum: "c8964e8a20c2e74199cf40848b7b14afc95a4f3dcae80a4dba974acf54d253ac"
        // )
    ]
)

let InstntAriesVCXTarget = package.targets.first(where: { $0.name == "InstntAriesVCX" })

package.targets.append(.binaryTarget(
        name: "VCX_uniffiFFI_Lib_zip",
        path: url: "https://github.com/instnt-inc/instnt-aries-vcx/releases/download/abhishek_GithubAction2/vcx.xcframework.zip",
        checksum: "c8964e8a20c2e74199cf40848b7b14afc95a4f3dcae80a4dba974acf54d253ac"
        ))

InstntAriesVCXTarget?.dependencies.append("VCX_uniffiFFI_Lib_zip")