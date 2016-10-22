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

let version = "1.0"

import atfoundation
import atpkg

setbuf(stdout, nil)

func usage() {
    print("xcode-emit \(version)")
    print("© 2016 Anarchy Tools Contributors.")
    print()
    print("Usage: xcode-emit [task]")
}


if CommandLine.arguments.count <= 1 {
    usage()
    exit(1)
}
if CommandLine.arguments[1] == "--help" {
    usage()
    exit(1)
}
var testTaskName: String? = nil

for (x,arg) in CommandLine.arguments.enumerated() {
    if arg == "--platform" && CommandLine.arguments[x+1] == "ios" {
        iosPlatform = true
    }
    if arg == "--test-task" {
        testTaskName = CommandLine.arguments[x+1]
    }
}

let taskName = CommandLine.arguments[1]


let package = try! Package(filepath:Path("build.atpkg"), overlay: [], focusOnTask:taskName)


guard let task = package.tasks[taskName] else { fatalError("Can't find task named \(taskName)")}
let testTask: Task?
if let t = testTaskName {
    guard let t_ = package.tasks[t] else { fatalError("Can't find task named \(t)")}
    testTask = t_
}
else { testTask = nil }
emit(task: task, testTask: testTask, package: package)