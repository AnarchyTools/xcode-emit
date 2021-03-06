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

#if os(OSX)
import Darwin
#else
import Glibc
#endif
import atfoundation

private func _WSTATUS(_ status: CInt) -> CInt {
    return status & 0x7f
}

private func WIFEXITED(_ status: CInt) -> Bool {
    return _WSTATUS(status) == 0
}

private func WEXITSTATUS(_ status: CInt) -> CInt {
    return (status >> 8) & 0xff
}

/// convenience wrapper for waitpid
private func waitpid(_ pid: pid_t) -> Int32 {
    while true {
        var exitStatus: Int32 = 0
        let rv = waitpid(pid, &exitStatus, 0)

        if rv != -1 {
            if WIFEXITED(exitStatus) {
                return WEXITSTATUS(exitStatus)
            } else {
                fatalError("Exit signal")
            }
        } else if errno == EINTR {
            continue  // see: man waitpid
        } else {
            fatalError("waitpid: \(errno)")
        }
    }
}

///A wrapper for POSIX "system" call.
///If return value is non-zero, we exit (not fatalError)
///See #72 for details.
///- note: This function call is appropriate for commands that are user-perceivable (such as compilation)
///Rather than calls that aren't
func anarchySystem(_ cmd: String, environment: [String: String]) -> Int32 {
    var output = ""
    return anarchySystem(cmd, environment: environment, redirectOutput: &output)
}
func anarchySystem(_ cmd: String, environment: [String: String],redirectOutput: inout String) -> Int32 {
    var pid : pid_t = 0
    //copy a few well-known values
    var environment = environment
    for arg in ["PATH","HOME"] {
        if let path = getenv(arg) {
            environment[arg] = String(validatingUTF8: path)!
        }
    }
    var cmd = cmd
    cmd += ">/tmp/anarchySystem.out"
    let args: [String] =  ["sh","-c",cmd]
    let argv = args.map{ $0.withCString(strdup) }
    let env: [UnsafeMutablePointer<CChar>?] = environment.map{ "\($0.0)=\($0.1)".withCString(strdup) }
    
    let directory = try! FS.getWorkingDirectory()
    defer {try! FS.changeWorkingDirectory(path: directory)}
    if let e = environment["PWD"] {
        try! FS.changeWorkingDirectory(path: Path(e))
    }
    let status = posix_spawn(&pid, "/bin/sh",nil,nil,argv + [nil],env + [nil])


    if status != 0 {
        fatalError("spawn error \(status)")
    }

    let returnCode = waitpid(pid)
    redirectOutput = try! File(path: Path("/tmp/anarchySystem.out"), mode:.ReadOnly).readAll()!
    return returnCode
}