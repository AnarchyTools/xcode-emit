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

import atfoundation

enum OutputType {
    case Executable
    case StaticLibrary
    case Application
    case TestTarget
}

import atpkg
func emit(task: Task, testTask: Task?, package: Package) {
    precondition(task.tool == "atllbuild", "Unsupported tool \(task.tool)")
    //make the xcodeproj directory
    guard let taskname = task["name"]?.string else { fatalError("No task name.")}
    let xcodeproj = Path(taskname+".xcodeproj")
    let _ = try? FS.removeItem(path: xcodeproj, recursive: true)
    try! FS.createDirectory(path: xcodeproj)
    let project = pbxproj(task: task, testTask: testTask, package: package)
    let str = project.serialize()
    try! str.write(to: Path("\(xcodeproj)/project.pbxproj"))

    try! FS.createDirectory(path: Path("\(xcodeproj)/xcshareddata/xcschemes"), intermediate: true)
    let schemes = xcscheme(project: project)
    try! schemes.write(to: Path("\(xcodeproj)/xcshareddata/xcschemes/\(taskname).xcscheme"))

}

func process(tasks: [Task], testTask: Task?, package: Package, xcodeprojGUID: String) -> [PbxprojSerializable] {
    let task = tasks[0] //pull off head
    //are there dependencies?
    var objects: [PbxprojSerializable] = []
    
    if tasks.count > 1 {
        let nextTasks = Array(tasks[1..<tasks.count])
        objects.append(contentsOf: process(tasks: nextTasks, testTask: nil, package: package, xcodeprojGUID: xcodeprojGUID))
    }
    guard let taskname = task["name"]?.string else { fatalError("No task name.")}
    guard let sourceDescriptions = task["sources"]?.vector?.flatMap({$0.string}) else { fatalError("Can't find sources for atllbuild.") }
    let sources = collectSources(sourceDescriptions: sourceDescriptions, taskForCalculatingPath: task)
    //emit the pbxproj
    let outputType : OutputType
    if task["output-type"]?.string == "executable" {
        if iosPlatform {
            outputType = .Application
        }
        else { outputType = .Executable }
    }
    else if task["output-type"]?.string == "static-library" {
        outputType = .StaticLibrary
    }
    else {
        fatalError("Unsupported output type \(task["output-type"])")
    }
    
    var linkWith : [PbxProductReference] = []
    if let l = task["link-with-product"]?.vector {
        for item in l {
            guard let str = item.string else { fatalError("Not string link target \(item)")}
            //find the productRef to link to
            for object in objects {
                guard let file = object as? PbxProductReference else { continue }
                precondition(str.hasSuffix(".a")) //not sure what to do in this case
                if file.name + ".a" == str {
                    linkWith.append(file)
                    //because we use dynamic libraries (due to rdar://24221024)
                    //we have to link with all our dependencies' linkWith as well
                    for o in objects {
                        //find the target for the file we're linking
                        guard let target = o as? PbxNativeTarget else { continue }
                        if target.productReference.name != file.name { continue }
                        //append its dependencies
                        linkWith.append(contentsOf: target.linkFiles)
                    }
                    break
                }
                else { print("didn't match \(file.name) \(str)") }
            }
        }
    }
    let type :PbxProductReference.ReferenceType
    if iosPlatform {
        type = PbxProductReference.ReferenceType.Application
    }
    else {
        type = PbxProductReference.ReferenceType.Executable
    }
    let product = PbxProductReference(name: taskname, type:type)
    let sourceRefs = sources.map() {PbxSourceFileReference(path:$0.description)}

    

    let target = PbxNativeTarget(productReference: product, outputType: outputType, sourceFiles: sourceRefs, linkFiles: linkWith, appTarget: nil, xcodeprojGUID: xcodeprojGUID )
    objects.append(target)
    objects.append(product)

    if let testTask = testTask {
        guard let testSourceDescriptions = testTask["sources"]?.vector?.flatMap({$0.string}) else { fatalError("Can't find sources for atllbuild.") }
        let sources = collectSources(sourceDescriptions: testSourceDescriptions, taskForCalculatingPath: testTask).map() {PbxSourceFileReference(path: $0.description)}
        let testProduct = PbxProductReference(name: taskname+"Tests", type: .TestTarget)
        let testTarget = PbxNativeTarget(productReference: testProduct, outputType: .TestTarget, sourceFiles: sources, linkFiles: [], appTarget: target, xcodeprojGUID: xcodeprojGUID)
        objects.append(testProduct)
        objects.append(testTarget)
        for o in sources {
            objects.append(o)
        }
    }


    for sourceRef in sourceRefs {
        objects.append(sourceRef)
    }
    for file in target.otherFiles {
        objects.append(file)
    }
    return objects
}

func pbxproj(task: Task, testTask: Task?, package: Package) -> Pbxproj {
    let guid = xcodeguid()
    var targets : [PbxNativeTarget] = []
    var objects = process(tasks: package.prunedDependencyGraph(task: task).reversed(), testTask: testTask, package: package, xcodeprojGUID: guid)
    for object in objects {
        if type(of: object) == PbxNativeTarget.self {
            targets.append(object as! PbxNativeTarget)
        }
    }
    let project = Pbxproject( guid: guid, targets: targets)
    objects.append(project)
    let groups = PbxGroups(targets: targets)
    objects.append(groups)
    let p = Pbxproj(objects: objects, rootObjectGUID: project.guid)
    return p
}