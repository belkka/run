# run --- run source file

Execute small one-file programs:

```
$ run helloworld.cpp
$ run hellokitty.java
$ run hellosnake.py  # well, actually not so useful
$ run hellomoon.lua
```

More languages coming soon!


## How it works

There is a set of so called "runfiles" in the directory 'runfile/'. runfile is a makefile that has recipes for .PHONY targets *compile*, *run*, *clean* and *match* which deal with make variable named 'src'

* recipe for target *match* must check if file $(src) can be handled by this runfile and exit with non-zero if it doesn't
* recipe for target *compile* must produce all neccecary files for immediate run (compile, produce bytecode for virtual machine etc.)
* recipe for target *run* must run the program
* recipe for target *clean* must remove files produced during execution of `make compile`

### Example runfile:
```
#!/usr/bin/make -f
.PHONY: run compile clean match

run: compile
	./a.out

compile: a.out

a.out: $(src)
	gcc ($src)

clean:
	-rm a.out

match:
	case $(src) in *.c) exit;; esac; exit 1
```
