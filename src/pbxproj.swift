// Copyright (c) 2016 Anarchy Tools Contributors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
var iosPlatform = false
import Darwin
import atfoundation



func xcodeguid() -> String {
    let choices = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]
    var guid = ""
    for _ in 0..<24 {
        let randomIndex = Int(arc4random_uniform(UInt32(choices.count)))
        guid += choices[randomIndex]
    }
    return guid
}
protocol PbxprojSerializable {
    func serialize() -> String
}
struct Pbxproj: PbxprojSerializable {
    var objects: [PbxprojSerializable] = []
    var rootObjectGUID: String 
    func serialize() -> String {
        var s = "{\n"
        s += "archiveVersion = 1;\n"
        s += "classes = {\n"
        s += "};\n"
        s += "objectVersion = 46;\n"
        s += "objects = {\n"
        for obj in objects {
            s += obj.serialize()
        }
        s += "};\n"
        s += "rootObject = \(rootObjectGUID);\n"
        s += "}\n"
        return s
    }
}



struct Pbxproject: PbxprojSerializable {
    let guid : String
    var targets: [PbxNativeTarget]
    let hacks = PbxConfigurationHacks()

    func serialize() -> String {
        var s = "/* Begin PBXProject section */\n"
        s += "\(guid) /* Project object */= {\n"
        s += "  isa = PBXProject;\n"
        s += "  attributes = {\n"
        s += "      LastSwiftUpdateCheck = 0720;\n"
        s += "      LastUpgradeCheck = 0720;\n"
        s += "      ORGANIZATIONNAME = \"Anarchy Tools\";\n"
        s += "      TargetAttributes = {\n"
        for target in targets {
            s += "          \(target.guid) = {\n"
            s += "              CreatedOnToolsVersion = 7.2;\n"
            s += "          };\n"
        }
        s += "      };\n"
        s += "  };\n"
        //this guid comes from PbxConfigurationHacks
        s += "  buildConfigurationList = 3ACD1A7D1C4ADB0A001919F6 /* Build configuration list for PBXProject */;\n"
        s += "  compatibilityVersion = \"Xcode 3.2\";\n"
        s += "  developmentRegion = English;\n"
        s += "  hasScannedForEncodings = 0;\n"
        s += "  knownRegions = (\n"
        s += "      en,\n"
        s += "  );\n"
        s += "  mainGroup = 3ACD1A791C4ADB0A001919F6; \n"
        s += "  productRefGroup = 3ACD1A831C4ADB0A001919F6 /* Products */;\n"
        s += "  projectDirPath = \"\";\n"
        s += "  projectRoot = \"\";\n"
        s += "  targets = (\n"
        for target in targets {
            s += "      \(target.guid) /* \(target.name) */, \n"
        }
        s += "  );\n"
        s += "};\n"
        s += hacks.serialize()
        return s
    }
}

/**Some day may want to separate this out into proper objects and whatnot, but until then */
struct PbxConfigurationHacks : PbxprojSerializable {
    func serialize() -> String {
        var s = ""
        s += "/* Begin XCConfigurationList section */\n"
        s += "3ACD1A7D1C4ADB0A001919F6 /* Build configuration list for PBXProject */ = {\n"
        s += "    isa = XCConfigurationList;\n"
        s += "    buildConfigurations = (\n"
        s += "        3ACD1A871C4ADB0A001919F6 /* Debug */,\n"
        s += "        3ACD1A881C4ADB0A001919F6 /* Release */,\n"
        s += "    );\n"
        s += "    defaultConfigurationIsVisible = 0;\n"
        s += "    defaultConfigurationName = Release;\n"
        s += "};\n"
        s += "3ACD1A891C4ADB0A001919F6 /* Build configuration list for PBXNativeTarget */ = {\n"
        s += "    isa = XCConfigurationList;\n"
        s += "    buildConfigurations = (\n"
        s += "        3ACD1A8A1C4ADB0A001919F6 /* Debug */,\n"
        s += "        3ACD1A8B1C4ADB0A001919F6 /* Release */,\n"
        s += "    );\n"
        s += "    defaultConfigurationIsVisible = 0;\n"
        s += "};\n"
        s += "/* End XCConfigurationList section */\n"
        s += "\n"
        s += "/* Begin XCBuildConfiguration section */\n"
        s += "3ACD1A871C4ADB0A001919F6 /* Debug */ = {\n"
        s += "    isa = XCBuildConfiguration;\n"
        s += "    buildSettings = {\n"
        s += "        ALWAYS_SEARCH_USER_PATHS = NO;\n"
        s += "        CLANG_CXX_LANGUAGE_STANDARD = \"gnu++0x\";\n"
        s += "        CLANG_CXX_LIBRARY = \"libc++\";\n"
        s += "        CLANG_ENABLE_MODULES = YES;\n"
        s += "        CLANG_ENABLE_OBJC_ARC = YES;\n"
        s += "        CLANG_WARN_BOOL_CONVERSION = YES;\n"
        s += "        CLANG_WARN_CONSTANT_CONVERSION = YES;\n"
        s += "        CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;\n"
        s += "        CLANG_WARN_EMPTY_BODY = YES;\n"
        s += "        CLANG_WARN_ENUM_CONVERSION = YES;\n"
        s += "        CLANG_WARN_INT_CONVERSION = YES;\n"
        s += "        CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;\n"
        s += "        CLANG_WARN_UNREACHABLE_CODE = YES;\n"
        s += "        CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;\n"
        s += "        CODE_SIGN_IDENTITY = \"-\";\n"
        s += "        COPY_PHASE_STRIP = NO;\n"
        s += "        DEBUG_INFORMATION_FORMAT = dwarf;\n"
        s += "        ENABLE_STRICT_OBJC_MSGSEND = YES;\n"
        s += "        ENABLE_TESTABILITY = YES;\n"
        s += "        GCC_C_LANGUAGE_STANDARD = gnu99;\n"
        s += "        GCC_DYNAMIC_NO_PIC = NO;\n"
        s += "        GCC_NO_COMMON_BLOCKS = YES;\n"
        s += "        GCC_OPTIMIZATION_LEVEL = 0;\n"
        s += "        GCC_PREPROCESSOR_DEFINITIONS = (\n"
        s += "            \"DEBUG=1\",\n"
        s += "            \"$(inherited)\",\n"
        s += "        );\n"
        s += "        GCC_WARN_64_TO_32_BIT_CONVERSION = YES;\n"
        s += "        GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;\n"
        s += "        GCC_WARN_UNDECLARED_SELECTOR = YES;\n"
        s += "        GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;\n"
        s += "        GCC_WARN_UNUSED_FUNCTION = YES;\n"
        s += "        GCC_WARN_UNUSED_VARIABLE = YES;\n"
        s += "        MACOSX_DEPLOYMENT_TARGET = 10.11;\n"
        s += "        MTL_ENABLE_DEBUG_INFO = YES;\n"
        s += "        ONLY_ACTIVE_ARCH = YES;\n"
        if iosPlatform {
            s += "        SDKROOT = iphoneos;\n"
            s += "        \"CODE_SIGN_IDENTITY[sdk=iphoneos*]\" = \"iPhone Developer\";\n"
        }
        else {
            s += "        SDKROOT = macosx;\n"
        }
        s += "        SWIFT_OPTIMIZATION_LEVEL = \"-Onone\";\n"
        s += "        SWIFT_VERSION = \"3.0\";\n"
        s += "    };\n"
        s += "    name = Debug;\n"
        s += "};\n"
        s += "3ACD1A881C4ADB0A001919F6 /* Release */ = {\n"
        s += "    isa = XCBuildConfiguration;\n"
        s += "    buildSettings = {\n"
        s += "        ALWAYS_SEARCH_USER_PATHS = NO;\n"
        s += "        CLANG_CXX_LANGUAGE_STANDARD = \"gnu++0x\";\n"
        s += "        CLANG_CXX_LIBRARY = \"libc++\";\n"
        s += "        CLANG_ENABLE_MODULES = YES;\n"
        s += "        CLANG_ENABLE_OBJC_ARC = YES;\n"
        s += "        CLANG_WARN_BOOL_CONVERSION = YES;\n"
        s += "        CLANG_WARN_CONSTANT_CONVERSION = YES;\n"
        s += "        CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;\n"
        s += "        CLANG_WARN_EMPTY_BODY = YES;\n"
        s += "        CLANG_WARN_ENUM_CONVERSION = YES;\n"
        s += "        CLANG_WARN_INT_CONVERSION = YES;\n"
        s += "        CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;\n"
        s += "        CLANG_WARN_UNREACHABLE_CODE = YES;\n"
        s += "        CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;\n"
        s += "        CODE_SIGN_IDENTITY = \"-\";\n"
        s += "        COPY_PHASE_STRIP = NO;\n"
        s += "        DEBUG_INFORMATION_FORMAT = \"dwarf-with-dsym\";\n"
        s += "        ENABLE_NS_ASSERTIONS = NO;\n"
        s += "        ENABLE_STRICT_OBJC_MSGSEND = YES;\n"
        s += "        GCC_C_LANGUAGE_STANDARD = gnu99;\n"
        s += "        GCC_NO_COMMON_BLOCKS = YES;\n"
        s += "        GCC_WARN_64_TO_32_BIT_CONVERSION = YES;\n"
        s += "        GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;\n"
        s += "        GCC_WARN_UNDECLARED_SELECTOR = YES;\n"
        s += "        GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;\n"
        s += "        GCC_WARN_UNUSED_FUNCTION = YES;\n"
        s += "        GCC_WARN_UNUSED_VARIABLE = YES;\n"
        s += "        MACOSX_DEPLOYMENT_TARGET = 10.11;\n"
        s += "        MTL_ENABLE_DEBUG_INFO = NO;\n"
        if iosPlatform {
            s += "        SDKROOT = iphoneos;\n"
            s += "        \"CODE_SIGN_IDENTITY[sdk=iphoneos*]\" = \"iPhone Developer\";\n"
        }
        else {
            s += "        SDKROOT = macosx;\n"
        }
        s += "        SWIFT_VERSION = \"3.0\";\n"

        s += "    };\n"
        s += "    name = Release;\n"
        s += "};\n"
        s += "/* End XCBuildConfiguration section */\n"
        return s
    }
}


struct PbxGroups : PbxprojSerializable {

    struct PbxGroupTarget {
        let target: PbxNativeTarget
        let sourceGroupGUID: String = xcodeguid()
    }

    let targets: [PbxGroupTarget]
    init(targets: [PbxNativeTarget]) {
        self.targets = targets.map() {PbxGroupTarget(target: $0)}
    }
    func serialize() -> String {
        var s = ""
        s += "/* Begin PBXGroup section */\n"
        s += "    3ACD1A791C4ADB0A001919F6 = {\n"
        s += "        isa = PBXGroup;\n"
        s += "        children = (\n"
        for target in targets {
            s += "            \(target.sourceGroupGUID) /* \(target.target.productReference.name) */,\n"
        }
        s += "            3ACD1A831C4ADB0A001919F6 /* Products */,\n"
        s += "        );\n"
        s += "        sourceTree = \"<group>\";\n"
        s += "    };\n"
        s += "    3ACD1A831C4ADB0A001919F6 /* Products */ = {\n"
        s += "        isa = PBXGroup;\n"
        s += "        children = (\n"
        for target in targets {
            s += "            \(target.target.productReference.guid) /* \(target.target.productReference.name) */,\n"
        }
        s += "        );\n"
        s += "        name = Products;\n"
        s += "        sourceTree = \"<group>\";\n"
        s += "    };\n"
        for target in targets {
            s += "    \(target.sourceGroupGUID) /* \(target.target.productReference.name) */ = {\n"
            s += "        isa = PBXGroup;\n"
            s += "        children = (\n"
            for file in target.target.sourceFiles {
                s += "            \(file.guid) /* \(file.path) */,\n"
            }
            for file in target.target.otherFiles {
                s += "            \(file.guid) /* \(file.path) */,\n"
            }
            s += "        );\n"
            s += "        path = \".\";\n"
            s += "        name = \"\(target.target.name)\";\n"
            s += "        sourceTree = \"<group>\";\n"
            s += "    };\n"
        }
        s += "/* End PBXGroup section */\n"
        return s
    }
}

class TargetWrapper {
    var target: PbxNativeTarget

    init(target: PbxNativeTarget) { self.target = target }
}

struct PbxNativeTarget: PbxprojSerializable {
    let guid = xcodeguid()
    let productReference: PbxProductReference
    var name : String { return productReference.name }
    let outputType: OutputType 
    let sourceFiles: [PbxSourceFileReference]
    let linkFiles: [PbxProductReference]
    let configurationList: PbxTargetConfigurations

    let dependencies: [PbxTargetDependency]

    let appTarget: TargetWrapper?

    //todo: This should be a more generic type than plists
    let otherFiles: [PbxFileReference]

    let phases: PbxPhases

    init(productReference: PbxProductReference, outputType: OutputType, sourceFiles: [PbxSourceFileReference], linkFiles:[PbxProductReference], otherFiles: [PbxFileReference], appTarget: PbxNativeTarget?, xcodeprojGUID: String) {
        if let a = appTarget {
            self.appTarget = TargetWrapper(target: a)
        }
        else { self.appTarget = nil}
        self.productReference = productReference
        self.outputType = outputType
        self.phases = PbxPhases(sourceFiles: sourceFiles, linkFiles: linkFiles)
        self.sourceFiles = sourceFiles
        self.linkFiles = linkFiles
        switch (outputType) {
            case .Application:
            var s = ""
            s += "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
            s += "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n"
            s += "<plist version=\"1.0\">\n"
            s += "<dict>\n"
            s += "  <key>CFBundleDevelopmentRegion</key>\n"
            s += "  <string>en</string>\n"
            s += "  <key>CFBundleExecutable</key>\n"
            s += "  <string>$(EXECUTABLE_NAME)</string>\n"
            s += "  <key>CFBundleIdentifier</key>\n"
            s += "  <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>\n"
            s += "  <key>CFBundleInfoDictionaryVersion</key>\n"
            s += "  <string>6.0</string>\n"
            s += "  <key>CFBundleName</key>\n"
            s += "  <string>$(PRODUCT_NAME)</string>\n"
            s += "  <key>CFBundlePackageType</key>\n"
            s += "  <string>APPL</string>\n"
            s += "  <key>CFBundleShortVersionString</key>\n"
            s += "  <string>1.0</string>\n"
            s += "  <key>CFBundleSignature</key>\n"
            s += "  <string>????</string>\n"
            s += "  <key>CFBundleVersion</key>\n"
            s += "  <string>1</string>\n"
            s += "  <key>LSRequiresIPhoneOS</key>\n"
            s += "  <true/>\n"
            s += "</dict>\n"
            s += "</plist>\n"
            let plistName = "\(productReference.name)-xcode-emit-Info.plist"
            try! s.write(to: Path(plistName))
            self.otherFiles = [PbxPlistFileReference(path: plistName)]
            self.configurationList = PbxTargetConfigurations(plistPath: plistName, testThisApp: nil)
            self.dependencies = []
            case .TestTarget:
            var s = ""
            s += "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
            s += "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n"
            s += "<plist version=\"1.0\">\n"
            s += "<dict>\n"
            s += "  <key>CFBundleDevelopmentRegion</key>\n"
            s += "  <string>en</string>\n"
            s += "  <key>CFBundleExecutable</key>\n"
            s += "  <string>$(EXECUTABLE_NAME)</string>\n"
            s += "  <key>CFBundleIdentifier</key>\n"
            s += "  <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>\n"
            s += "  <key>CFBundleInfoDictionaryVersion</key>\n"
            s += "  <string>6.0</string>\n"
            s += "  <key>CFBundleName</key>\n"
            s += "  <string>$(PRODUCT_NAME)</string>\n"
            s += "  <key>CFBundlePackageType</key>\n"
            s += "  <string>BNDL</string>\n"
            s += "  <key>CFBundleShortVersionString</key>\n"
            s += "  <string>1.0</string>\n"
            s += "  <key>CFBundleSignature</key>\n"
            s += "  <string>????</string>\n"
            s += "  <key>CFBundleVersion</key>\n"
            s += "  <string>1</string>\n"
            s += "  <key>LSRequiresIPhoneOS</key>\n"
            s += "  <true/>\n"
            s += "</dict>\n"
            s += "</plist>\n"
            let plistName = "\(productReference.name)-xcode-emit-Info.plist"
            try! s.write(to: Path(plistName))
            self.otherFiles = [PbxPlistFileReference(path: plistName)] + otherFiles
            self.configurationList = PbxTargetConfigurations(plistPath: plistName, testThisApp: appTarget!.name)
            self.dependencies = [PbxTargetDependency(target: appTarget!, projectGUID: xcodeprojGUID)]

            case .StaticLibrary, .Executable:
            self.configurationList = PbxTargetConfigurations(plistPath: nil, testThisApp: nil)
            self.otherFiles = otherFiles
            self.dependencies = []
        }
    }
    func serialize() -> String {
        var s = ""
        s += "/* Begin PBXNativeTarget section */\n"
        s += "\(guid) /*  */ = {\n"
        s += "    isa = PBXNativeTarget;\n"
        //this depends on PbxConfigurationHacks
        s += "    buildConfigurationList = \(configurationList.guid) /* Build configuration list for PBXNativeTarget */;\n"
        s += "    buildPhases = (\n"
        s += "        \(phases.sourcesGUID) /* Sources */,\n"
        s += "        \(phases.frameworksGUID) /* Frameworks */,\n"
        s += "        \(phases.copyFilesGUID) /* CopyFiles */,\n"
        s += "    );\n"
        s += "    buildRules = (\n"
        s += "    );\n"
        s += "    dependencies = (\n"
        for dependency in dependencies {
            s += "        \(dependency.guid) /* PBXTargetDependency */,\n"
        }
        s += "    );\n"
        s += "    name = \(name);\n"
        s += "    productName = \(name);\n"
        s += "    productReference = \(productReference.guid) /* \(productReference.name) */;\n"
        switch outputType {
        case .Executable:
            s += "    productType = \"com.apple.product-type.tool\";\n"
        case .StaticLibrary:
            print("Warning: working around rdar://24221024")
            s += "    productType = \"com.apple.product-type.library.dynamic\";"
        case .Application:
            s += "    productType = \"com.apple.product-type.application\";\n"
        case .TestTarget:
            s += "    productType = \"com.apple.product-type.bundle.unit-test\";\n"
        }
        s += "};\n"
        s += "/* End PBXNativeTarget section */\n"

        s += phases.serialize()

        s += configurationList.serialize()

        for dependency in dependencies {
            s += dependency.serialize()
        }
        return s
    }
}

struct PbxTargetConfigurations: PbxprojSerializable {
    let guid = xcodeguid()
    let debugGUID = xcodeguid()
    let releaseGUID = xcodeguid()
    let plistPath: String?
    ///If non-nil, we will emit a test target to test the given app.  Use the name of the executable, a.k.a. the app name without `.app` extension
    let testThisApp: String?


    func serialize() -> String {

        //these settings are used several times
        var sx = ""
        sx += "        PRODUCT_NAME = \"$(TARGET_NAME)\";\n"
        //particularly when building a dynamic library, we need to tell Swift where to find its standard library
        //@executable_path/Frameworks is for iOS/app bundles
        sx += "        LD_RUNPATH_SEARCH_PATHS = \"$(inherited) @executable_path/Frameworks /Library/Developer/Toolchains/swift-latest.xctoolchain/usr/lib/swift/macosx/\";\n"
        //once we give it its standard library dynamically, let's force the executable not to include it.
        sx += "        SWIFT_FORCE_DYNAMIC_LINK_STDLIB = YES;\n"
        if let plistPath = self.plistPath {
            sx += "        INFOPLIST_FILE = \(plistPath);\n"
        }
        sx += "        PRODUCT_BUNDLE_IDENTIFIER = org.anarchytools.XcodeEmittedApp-\(guid);\n"
        if let t = testThisApp {
            sx += "        BUNDLE_LOADER = \"$(TEST_HOST)\";\n"
            sx += "        LD_RUNPATH_SEARCH_PATHS = \"$(inherited) @executable_path/Frameworks @loader_path/Frameworks\";\n"
            sx += "        TEST_HOST = \"$(BUILT_PRODUCTS_DIR)/\(t).app/\(t)\";\n"
        }

        var s = ""
        s += "\(guid) /* Build configuration list for PBXNativeTarget */ = {\n"
        s += "    isa = XCConfigurationList;\n"
        s += "    buildConfigurations = (\n"
        s += "        \(debugGUID) /* Debug */,\n"
        s += "        \(releaseGUID) /* Release */,\n"
        s += "    );\n"
        s += "    defaultConfigurationIsVisible = 0;\n"
        s += "};\n"
        s += "\(debugGUID) /* Debug */ = {\n"
        s += "    isa = XCBuildConfiguration;\n"
        s += "    buildSettings = {\n"
        s += sx
        s += "    };\n"
        s += "    name = Debug;\n"
        s += "};\n"
        s += "\(releaseGUID) /* Release */ = {\n"
        s += "    isa = XCBuildConfiguration;\n"
        s += "    buildSettings = {\n"
        s += sx
        s += "    };\n"
        s += "    name = Release;\n"
        s += "};\n"
        return s
    }
}

struct PbxPhases: PbxprojSerializable {
    let sourceFiles: [PbxSourceFileReference]
    let linkFiles: [PbxProductReference]
    let copyFilesGUID = xcodeguid()
    let sourcesGUID = xcodeguid()
    let frameworksGUID = xcodeguid()

    func serialize() -> String {
        var s = ""
        s += "/* Begin PBXCopyFilesBuildPhase section */\n"
        s += "\(copyFilesGUID) /* CopyFiles */ = {\n"
        s += "    isa = PBXCopyFilesBuildPhase;\n"
        s += "    buildActionMask = 2147483647;\n"
        s += "    dstPath = /usr/share/man/man1/;\n"
        s += "    dstSubfolderSpec = 0;\n"
        s += "    files = (\n"
        s += "    );\n"
        s += "    runOnlyForDeploymentPostprocessing = 1;\n"
        s += "};\n"
        s += "/* End PBXCopyFilesBuildPhase section */\n"
        s += "/* Begin PBXFrameworksBuildPhase section */\n"
        s += "\(frameworksGUID) /* Frameworks */ = {\n"
        s += "    isa = PBXFrameworksBuildPhase;\n"
        s += "    buildActionMask = 2147483647;\n"
        s += "    files = (\n"
        for file in linkFiles {
            s += "        \(file.buildFile.guid) /* \(file.name) in Frameworks */,\n"
        }
        s += "    );\n"
        s += "    runOnlyForDeploymentPostprocessing = 0;\n"
        s += "};\n"
        s += "/* End PBXFrameworksBuildPhase section */\n"
        s += "/* Begin PBXSourcesBuildPhase section */\n"
        s += "\(sourcesGUID) /* Sources */ = {\n"
        s += "    isa = PBXSourcesBuildPhase;\n"
        s += "    buildActionMask = 2147483647;\n"
        s += "    files = (\n"
        for file in sourceFiles {
            s += "        \(file.buildFile.guid) /* \(file.path) in Sources */,\n"
        }
        s += "    );\n"
        s += "    runOnlyForDeploymentPostprocessing = 0;\n"
        s += "};\n"
        s += "/* End PBXSourcesBuildPhase section */\n"
        return s
    }
}

struct PbxProductReference: PbxprojSerializable {

    enum ReferenceType: String {
        case Executable = "compiled.mach-o.executable"
        case Application = "wrapper.application"
        case TestTarget = "wrapper.cfbundle"
    }

    let name: String
    let guid = xcodeguid()
    let buildFile: PbxBuildFile
    let type: ReferenceType

    private var path: String {
        switch(type){
            case .Executable:
            return name
            case .Application:
            return "\(name).app"
            case .TestTarget:
            return "\(name).xctest"
        }
    }

    init(name: String, type: ReferenceType) {
        self.name = name
        self.buildFile = PbxBuildFile(path: name, fileRefGUID: guid)
        self.type = type
    }
    func serialize() -> String {
        var s =  "\(guid) /* \(name) */ = {isa = PBXFileReference; explicitFileType = \"\(self.type.rawValue)\"; includeInIndex = 0; path = \"\(path)\"; sourceTree = BUILT_PRODUCTS_DIR; };\n"
        s += buildFile.serialize()
        return s
    }
}

///a generic type for anything in the PBXFileReference section
///todo: consider reparenting existing types to this
protocol PbxFileReference: PbxprojSerializable {
    var guid: String { get }
    var path: String { get }
}

struct PbxBuildFile: PbxprojSerializable {
    let guid = xcodeguid()
    let path: String
    let fileRefGUID: String
    func serialize() -> String {
        return "\(guid) /* \(path) in Sources */ = {isa = PBXBuildFile; fileRef = \(fileRefGUID) /* \(path) */; };\n"
    }
}

struct PbxStaticLibraryFileReference: PbxprojSerializable {
    let path: String
    let guid = xcodeguid()
    let buildFile: PbxBuildFile
    init(path: String) {
        self.path = path
        buildFile = PbxBuildFile(path: path, fileRefGUID: guid)
    }
    func serialize() -> String {
        var s = "\(guid) /* \(path) */ = {isa = PBXFileReference; lastKnownFileType = archive.ar; name = \(path); path = \"\(path)\"; sourceTree = \"<group>\"; };"
        s += buildFile.serialize()
        return s
    }
}

struct PbxPlistFileReference: PbxFileReference {
    let path: String
    let guid = xcodeguid()
    init(path: String) {
        self.path = path
    }
    func serialize() -> String {
        var s = "\(guid) /* \(path) */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; name = \(path); path = \"\(path)\"; sourceTree = \"<group>\"; };"
        return s
    }
}

struct PbxHeaderFileReference: PbxFileReference {
    let path: String
    let guid = xcodeguid()
    init(path: String) {
        self.path = path
    }
    func serialize() -> String {
        var s = "\(guid) /* \(path) */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.c.h; name = \(path); path = \"\(path)\"; sourceTree = \"<group>\"; };"
        return s
    }
}

struct PbxTargetDependency : PbxprojSerializable {
    let guid = xcodeguid()
    let target : PbxNativeTarget

    let targetProxyGUID = xcodeguid()
    let projectGUID: String

    func serialize() -> String {
        var s = ""
        s += "\(guid) /* PBXTargetDependency */ = {\n"
        s += "    isa = PBXTargetDependency;\n"
        s += "    target = \(target.guid) /* main */;\n"
        s += "    targetProxy = \(targetProxyGUID) /* PBXContainerItemProxy */;\n"
        s += "};\n"
        s += "    \(targetProxyGUID) /* PBXContainerItemProxy */ = {\n"
        s += "     isa = PBXContainerItemProxy;\n"
        s += "    containerPortal = \(projectGUID) /* Project object */;\n"
        s += "    proxyType = 1;\n"
        s += "    remoteGlobalIDString = \(target.guid);\n"
        s += "    remoteInfo = \(target.name);\n"
        s += "};\n"
        return s
    }
}

struct PbxSourceFileReference: PbxprojSerializable  {
    let path: String
    let guid = xcodeguid()
    let buildFile : PbxBuildFile
    init(path: String) {
        self.path = path
        buildFile = PbxBuildFile(path: path, fileRefGUID: guid)
    }
    func serialize() -> String {
        var s = "\(guid) /* \(path) */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = \"\(path)\"; sourceTree = \"<group>\"; };\n"
        s += buildFile.serialize()
        return s
    }
}