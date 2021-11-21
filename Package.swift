// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RemoteImageView", // Package name
	platforms: [.iOS(.v13)],  // only for iOS 13 and higher
	
	// The products this Package offers. These can be a library or an executable.
	// A `product` is a `target` that will be exported for other Packages to use.
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "RemoteImageView", targets: ["RemoteImageView"]),
    ],
	
	// any dependencies required by this Package, specified as a URL to the Git repo containing the code, along with the version required.
    dependencies: [
        // .package(url: /* required package url */, from: "1.0.0"),
    ],
	
	// Targets are modules of code that are built independently.
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "RemoteImageView", dependencies: []),
        .testTarget(name: "RemoteImageViewTests", dependencies: ["RemoteImageView"]),
    ]
)
