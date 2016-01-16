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

//todo: this was stolen from atbuild/atllbuild.swift.  Maybe we should refactor this in some way.
/**
 * This function resolves wildcards in source descriptions to complete values
 *   - parameter sourceDescriptions: a descriptions of sources such as ["src/**.swift"] */
 *   - returns: A list of resolved sources such as ["src/a.swift", "src/b.swift"]
 */
func collectSources(sourceDescriptions: [String]) -> [String] {
    var sources : [String] = []
    for description in sourceDescriptions {
        if description.hasSuffix("**.swift") {
            let basepath = String(Array(description.characters)[0..<description.characters.count - 9])
            let manager = NSFileManager.defaultManager()
            let enumerator = manager.enumeratorAtPath(basepath)!
            while let source = enumerator.nextObject() as? String {
                if source.hasSuffix("swift") {
                    sources.append(basepath + "/" + source)
                }
            }
        }
        else {
            sources.append(description)
        }
    }
    return sources
}

enum OutputType {
    case Executable
    case StaticLibrary
}

import atpkg
func emit(task: Task, package: Package) {
    precondition(task.tool == "atllbuild", "Unsupported tool \(task.tool)")
    //make the xcodeproj directory
    guard let taskname = task["name"]?.string else { fatalError("No task name.")}
    let xcodeproj = taskname+".xcodeproj"
    let manager = NSFileManager.defaultManager()
    let _ = try? manager.removeItemAtPath(xcodeproj)
    try! manager.createDirectoryAtPath(xcodeproj, withIntermediateDirectories: false, attributes: nil)
    let str = pbxproj(task, package: package)
    try! str.writeToFile("\(xcodeproj)/project.pbxproj", atomically: false, encoding: NSUTF8StringEncoding)
}

func process(task: Task, package: Package) -> [PbxprojSerializable] {
    //are there dependencies?
    var objects: [PbxprojSerializable] = []
    if let dependencies = task["dependencies"]?.vector {
        for dependency in dependencies {
            guard let depname = dependency.string else { fatalError("Non-string dependency \(dependency)")}
            guard let dep = package.tasks[depname] else { fatalError("Can't find dependency \(depname)")}
            objects.appendContentsOf(process(dep, package: package))
        }
    }
    guard let taskname = task["name"]?.string else { fatalError("No task name.")}
    guard let sourceDescriptions = task["source"]?.vector?.flatMap({$0.string}) else { fatalError("Can't find sources for atllbuild.") }
    let sources = collectSources(sourceDescriptions)
    //emit the pbxproj
    let outputType : OutputType
    if task["outputType"]?.string == "executable" {
        outputType = .Executable
    }
    else if task["outputType"]?.string == "static-library" {
        outputType = .StaticLibrary
    }
    else {
        fatalError("Unsupported output type \(task["outputType"])")
    }
    
    var linkWith : [String] = []
    if let l = task["linkWithProduct"]?.vector {
        for item in l {
            guard let str = item.string else { fatalError("Not string link target \(item)")}
            linkWith.append(".atllbuild/products/"+str)
        }
    }

    let hacks = PbxConfigurationHacks()
    let product = PbxProductReference(name: taskname)
    let sourceRefs = sources.map() {PbxSourceFileReference(path:$0)}
    let linkRefs = linkWith.map() {PbxStaticLibraryFileReference(path:$0)}

    let groups = PbxGroups(productReference: product, sourceFiles: sourceRefs, linkFiles: linkRefs)
    let target = PbxNativeTarget(productReference: product, outputType: outputType, sourceFiles: sourceRefs, linkFiles: linkRefs)
    let otmp: [PbxprojSerializable] = [hacks, groups, target, product]
    objects.appendContentsOf(otmp)
    for sourceRef in sourceRefs {
        objects.append(sourceRef)
    }
    for linkRef in linkRefs {
        objects.append(linkRef)
    }
    return objects
}

func pbxproj(task: Task, package: Package) -> String {
    var targets : [PbxNativeTarget] = []
    var objects = process(task, package: package)
    for object in objects {
        if object.dynamicType == PbxNativeTarget.self {
            targets.append(object as! PbxNativeTarget)
        }
    }
    let project = Pbxproject(targets: targets)
    objects.append(project)
    var p = Pbxproj(objects: objects, rootObjectGUID: project.guid)
    return p.serialize()
}