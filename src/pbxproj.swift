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
import Foundation

private func xcodeguid() -> String {
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
    var guid = xcodeguid()
    func serialize() -> String {
        var s = "/* Begin PBXProject section */\n"
        s += "\(guid) /* Project object */= {\n"
        s += "  isa = PBXProject;\n"
        s += "  attributes = {\n"
        s += "      LastSwiftUpdateCheck = 0720;\n"
        s += "      LastUpgradeCheck = 0720;\n"
        s += "      ORGANIZATIONNAME = \"Anarchy Tools\";\n"
        s += "      TargetAttributes = {\n"
        s += "          3ACD1A811C4ADB0A001919F6 = {\n"
        s += "              CreatedOnToolsVersion = 7.2;\n"
        s += "          };\n"
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
        s += "      3ACD1A811C4ADB0A001919F6 /*  */, \n"
        s += "  );\n"
        s += "};\n"
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
        s += "        SDKROOT = macosx;\n"
        s += "        SWIFT_OPTIMIZATION_LEVEL = \"-Onone\";\n"
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
        s += "        SDKROOT = macosx;\n"
        s += "    };\n"
        s += "    name = Release;\n"
        s += "};\n"
        s += "3ACD1A8A1C4ADB0A001919F6 /* Debug */ = {\n"
        s += "    isa = XCBuildConfiguration;\n"
        s += "    buildSettings = {\n"
        s += "        PRODUCT_NAME = \"$(TARGET_NAME)\";\n"
        s += "    };\n"
        s += "    name = Debug;\n"
        s += "};\n"
        s += "3ACD1A8B1C4ADB0A001919F6 /* Release */ = {\n"
        s += "    isa = XCBuildConfiguration;\n"
        s += "    buildSettings = {\n"
        s += "        PRODUCT_NAME = \"$(TARGET_NAME)\";\n"
        s += "    };\n"
        s += "    name = Release;\n"
        s += "};\n"
        s += "/* End XCBuildConfiguration section */\n"
        return s
    }
}

struct PbxGroups : PbxprojSerializable {
    let productReference: PbxProductReference
    func serialize() -> String {
        var s = ""
        s += "/* Begin PBXGroup section */\n"
        s += "    3ACD1A791C4ADB0A001919F6 = {\n"
        s += "        isa = PBXGroup;\n"
        s += "        children = (\n"
        s += "            3ACD1A841C4ADB0A001919F6 /* \(productReference.name) */,\n"
        s += "            3ACD1A831C4ADB0A001919F6 /* Products */,\n"
        s += "        );\n"
        s += "        sourceTree = \"<group>\";\n"
        s += "    };\n"
        s += "    3ACD1A831C4ADB0A001919F6 /* Products */ = {\n"
        s += "        isa = PBXGroup;\n"
        s += "        children = (\n"
        s += "            \(productReference.guid) /* \(productReference.name) */,\n"
        s += "        );\n"
        s += "        name = Products;\n"
        s += "        sourceTree = \"<group>\";\n"
        s += "    };\n"
        s += "    3ACD1A841C4ADB0A001919F6 /* \(productReference.name) */ = {\n"
        s += "        isa = PBXGroup;\n"
        s += "        children = (\n"
        //todo: emit files
        //s += "            3ACD1A851C4ADB0A001919F6 /* main.swift */,\n"
        //s += "            3ACD1A8C1C4ADB3D001919F6 /* atpkg.a */,\n"
        s += "        );\n"
        s += "        path = \(productReference.name);\n"
        s += "        sourceTree = \"<group>\";\n"
        s += "    };\n"
        s += "/* End PBXGroup section */\n"
        return s
    }
}

struct PbxNativeTarget: PbxprojSerializable {
    let guid = xcodeguid()
    let productReference: PbxProductReference
    func serialize() -> String {
        var s = ""
        s += "/* Begin PBXNativeTarget section */\n"
        s += "\(guid) /*  */ = {\n"
        s += "    isa = PBXNativeTarget;\n"
        //this depends on PbxConfigurationHacks
        s += "    buildConfigurationList = 3ACD1A891C4ADB0A001919F6 /* Build configuration list for PBXNativeTarget */;\n"
        s += "    buildPhases = (\n"
        //todo
        //s += "        3ACD1A7E1C4ADB0A001919F6 /* Sources */,\n"
        //s += "        3ACD1A7F1C4ADB0A001919F6 /* Frameworks */,\n"
        //s += "        3ACD1A801C4ADB0A001919F6 /* CopyFiles */,\n"
        s += "    );\n"
        s += "    buildRules = (\n"
        s += "    );\n"
        s += "    dependencies = (\n"
        s += "    );\n"
        s += "    name = SampleCLIApp;\n"
        s += "    productName = SampleCLIApp;\n"
        s += "    productReference = \(productReference.guid) /* \(productReference.name) */;\n"
        s += "    productType = \"com.apple.product-type.tool\";\n"
        s += "};\n"
        s += "/* End PBXNativeTarget section */\n"
        return s
    }
}

struct PbxProductReference: PbxprojSerializable {
    let name: String
    let guid = xcodeguid()
    func serialize() -> String {
        return "\(guid) /* \(name) */ = {isa = PBXFileReference; explicitFileType = \"compiled.mach-o.executable\"; includeInIndex = 0; path = \(name); sourceTree = BUILT_PRODUCTS_DIR; };\n"
    }
}

struct PbxFileReference {
    let name: String
    let guid = xcodeguid()
}