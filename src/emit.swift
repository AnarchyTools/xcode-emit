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

import atpkg
func emit(task: Task) {
    precondition(task.tool == "atllbuild", "Unsupported tool \(task.tool)")
    guard let sourceDescriptions = task["source"]?.vector?.flatMap({$0.string}) else { fatalError("Can't find sources for atllbuild.") }
    let sources = collectSources(sourceDescriptions)
    let str = pbxproj()
    //make the xcodeproj directory
    guard let taskname = task["name"]?.string else { fatalError("No task name.")}
    let xcodeproj = taskname+".xcodeproj"
    let manager = NSFileManager.defaultManager()
    let _ = try? manager.removeItemAtPath(xcodeproj)
    try! manager.createDirectoryAtPath(xcodeproj, withIntermediateDirectories: false, attributes: nil)
    try! str.writeToFile("\(xcodeproj)/project.pbxproj", atomically: false, encoding: NSUTF8StringEncoding)
}

func pbxproj() -> String {
    return "Invalid."
}