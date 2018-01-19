# run --- run source file

Execute small one-file programs:

```
$ run helloworld.cpp
$ run hellokitty.java
$ run hellosnake.py  # well, it is actually not so useful
$ run hellomoon.lua
```

More languages coming soon!


## Options

* `--compile` prepare program for `run`, but not run
* `--clean` clean produced binary files, not run
* `--cleanup` run and then clean produced binary files
* `--help` guess what


## How it works

There is a set of so called "runfiles" in the directory 'runfile/'. runfile is a makefile that has recipes for .PHONY targets *compile*, *run*, *clean* and *match* which deal with make variable named 'src'

* recipe for target **match** must check if file $(src) can be handled by this runfile and exit with non-zero if it doesn't
* recipe for target **compile** must produce from $(src) all files that are neccecary for immediate run (compile, produce bytecode for virtual machine etc.)
* recipe for target **run** must run the program and supposed to have target **compile** as prerequisite
* recipe for target **clean** must remove files produced by `make compile`

Runfiles are supposed to be used in this way:

```
$ make -f <runfile> [run|compile|clean|match] src=<source_code>
```

`run` is a script that looks for runfile in the runfile/ directory that handles *source_code* and executes
```
$ make -f <found_runfile> run src=<source_code>
```
if one is found

### Example runfile for C source code:
```
#!/usr/bin/make -f
.PHONY: run compile clean match

run: compile
	./a.out

compile: a.out

a.out: $(src)
	gcc $(src)

clean:
	-rm a.out

match:
	case $(src) in *.c) exit;; esac; exit 1
```
