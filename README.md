jit(1) -- compile source files as needed
========================================

## SYNOPSIS

jit translates a script into a binary on the first run of the script. This allows
for easier deployment of binary, native code - assuming the code itself is
OS independent (using `#ifdef` conditionals or similar mechanisms, where needed.)

## DESCRIPTION

**jit** translates a script into a binary when the script is run for the first time.
jit itself is independent from the language of the script by different "strategies". 
Current strategies include:

- **cc**: to compile a C source file using cc(1)
- **flex**: to compile a file via flex(1) and cc(1)

jit assumes the tools needed by a specific strategy - for example flex(1) and 
cc(1) - are installed on the target system.

Usually **jit** would be embedded in the target script. This is the hello world
example (also in examples/hello):

    #!/usr/bin/env jit cc --

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
    cc'ing ./examples/hello into /Users/eno/.jit//projects/native/jit/examples/hello
    Hello world

**Note:** jit's output (*cc'ing ./examples/hello ..*) is written to stderr to 
not mingle with anything printed from the script itself.

## CLEARING jitted BINARIES

It should not be necessary to manually clear a jitted binary. `jit` detects
a new version of a source script automatically and rebuilds the binary as 
needed. 

If you still feel the need to remove a binary just look for it in `$HOME/.jit`
and remove it.

## INSTALLATION

Download the jit script from github and put it somewhere in your path. 
The following commands, for example, would install `jit` into `/usr/local/bin`:

    sudo curl https://raw.github.com/radiospiel/jit/master/bin/jit > /usr/local/bin/jit
    sudo chmod a+x /usr/local/bin/jit

## FILES

jitted binaries are stored below `$HOME/.jit`.

## LIMITATIONS

Each jitted application must be implemented in a single source file.

## COPYRIGHT

**jit** is Copyright (C) 2013,1024 @radiospiel <https://github.com/radiospiel>

## SEE ALSO

cc(1), flex(1).
