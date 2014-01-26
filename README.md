jit(1) -- compile source files as needed
========================================

## SYNOPSIS

jit translates a script into a binary on the first run of the script. This allows
for easier deployment of binary, native code - assuming the code itself is
OS independant (using `#ifdef` conditionals or similar mechanisms)

## DESCRIPTION

**jit** translates a script into a binary when the script is run for the first time.
jit itself is independent from the language of the script by different "strategies". 
Current strategies include:

- **cc**: to compile a C source file using cc(1)
- **flex**: to compile a file via flex(1) and cc(1)

jit assumes the tools needed by a specific strategy are installed on the base system.

Usually **jit** would be embedded in the target script. This is the hello world
example (also in example/hello):

    #!/usr/bin/env jit cc

    #include <stdio.h>

    int main() {
      printf("Hello world\n");
      return 0;
    }

Make sure jit is installed and in your $PATH and set this script executable 
(`chmod o+x example/hello`). Now you can run this script directly. On the first 
invocation **jit** produces a binary; on subsequent invocations the already 
produced binary will be run again.

    ./example/hello
    cc'ing ./example/hello into /Users/eno/.jit//projects/native/jit/example/hello
    Hello world

**Note:** jit's output (*cc'ing ./example/hello ..*) is written to stderr to 
not mingle with anything print from the script itself.

## CLEARING jitted BINARIES

To clear a binary which was jitted from a specific sourcefile run: 

    `jit` clear sourcefile<br>

## INSTALLATION

Download the jit script from github and put it somewhere in your path.

## FILES

jitted binaries are stored below `$HOME/.jit`.

## LIMITATIONS

Each jitted application must be implemented in a single source file.

## COPYRIGHT

**jit** is Copyright (C) 2013,1024 @radiospiel <https://github.com/radiospiel>

## SEE ALSO

cc(1), flex(1).
