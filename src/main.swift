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

let version = "0.3.0"

import atfoundation
import atpkg

setbuf(stdout, nil)

func usage() {
    print("xcode-emit \(version)")
    print("© 2016 Anarchy Tools Contributors.")
    print()
    print("Usage: xcode-emit [task]")
}


if Process.arguments.count <= 1 {
    usage()
    exit(1)
}
if Process.arguments[1] == "--help" {
    usage()
    exit(1)
}
for (x,arg) in Process.arguments.enumerated() {
    if arg == "--platform" && Process.arguments[x+1] == "ios" {
        iosPlatform = true
    }
}

let taskName = Process.arguments[1]

let package = try! Package(filepath:Path("build.atpkg"), overlay: [], focusOnTask:taskName)


guard let task = package.tasks[taskName] else { fatalError("Can't find task named \(taskName)")}
emit(task: task, package: package)