# xcode-emit

xcode-emit generates a complete development Xcode project for an Anarchy Tools package. This allows you to develop any atbuild package in Xcode.

The project emitted is fully-functional, and should allow debugging in Xcode as well.  There may be minor differences from how `atbuild` builds packages; please file bugs if you spot them.

As the name suggests, `xcode-emit` is one-way.  Source code changes you make edit the source files themselves (and thus are preserved), but any Xcode build settings you change will be lost the next time you use `xcode-emit`.

# Usage

```
xcode-emit 0.1.0-dev
© 2016 Anarchy Tools Contributors.

Usage: xcode-emit [task]
```

