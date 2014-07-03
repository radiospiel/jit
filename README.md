jit.LANG(1) -- compile source files as needed
=============================================

## SYNOPSIS

jit.LANG translates a script into a binary on the first run of that script. 
This allows for easier deployment of binary, native code - assuming the code 
itself is OS independent (using `#ifdef` conditionals or similar mechanisms, 
where needed.)

jit.LANG is also helps to cross compile and distribute scripts.

## DESCRIPTION

**jit.LANG** translates a script into a binary when the script is run for the first time.
The jit main package itself is independent from the language of the script; there are
different language drivers.

Current drivers include:

- **jit.cc**: to compile a C source file using cc(1)
- **jit.flex**: to compile a file via flex(1) and cc(1)
- **jit.go**: to compile a go source file via go(1)

jit.LANG assumes the tools needed by a specific strategy - for example flex(1) and 
cc(1) - are installed on the target system.

To use jit a user would embed it in the target script. This is the hello world
example (also in examples/hello):

    #!/usr/bin/env jit.cc

    #include <stdio.h>

    int main() {
      printf("Hello world\n");
      return 0;
    }

Make sure jit is installed and in your $PATH and set this script executable 
(`chmod a+x examples/hello`). Now you can run this script directly. On the first 
invocation **jit** produces a binary; on subsequent invocations the already 
produced binary will be run again.

    ./examples/hello
    Building /Users/eno/projects/native/jit/examples/jit.cc.bin/hello
    Hello world

**Note:** jit's output (*Building ..*) is written to stderr to not mingle with anything printed from the script itself.

## INSTALLATION

Depending on your system

    make install

or

    sudo make install
    
installs all jit scripts into `/usr/local`.

## COMPILING BINARIES FOR DISTRIBUTION

jit can build binaries for distribution. These binaries are installed close to the source script,
in a subdirectory named `jit.LANG.bin`, if it exists. For example, when running the script 
"example/hello", the resulting binary will be placed, for example, into example/jit.cc.bin/hello.darwin.amd64. You can distribute that binary, if you wish.

This is most helpful with cross compilation to produce binaries, that can be run on 
platforms that are not that well-performing (say, arm), and with tool chains that 
support cross compilation right away (say, go). The jit.go driver supports cross compilation out
of the box.

To prevent distribution builds you either

- make sure the target directory does not exist or is not writable, and/or
- set the 'JIT_DIST_BUILD' environment variable to "n"

## ENVIRONMENT VALUES

- JIT_DIST_BUILD: set to "n" to prevent distribution builds.
- JIT_GO_TARGET_PLATFORMS: target platforms for go cross compilation.

## LIMITATIONS

- Each jitted application should be implemented in a single source file.
- The absolute path to a jitted application should not be too long - the jitted
  binary will be stored under a name which is longer than the original pathname.

## COPYRIGHT

The **jit** package is Copyright (C) 2013,1024 @radiospiel <https://github.com/radiospiel>.
It is released under the terms of the MIT license.
