#!/usr/bin/make -f
SHELL = bash

CLEAN = [ -f stdout ] && rm stdout; [ -f stderr ] && rm stderr;
OK = $(CLEAN) echo '$@: OK'
FAIL = $(CLEAN) echo FAIL; exit

.ONESHELL:
.SILENT:
.PHONY: testing stdout_hello_stderr_world sum4and7is11


testing: stdout_hello_stderr_world sum4and7is11


stdout_hello_stderr_world:
	./run test/stdout_hello_stderr_world.cpp --cleanup >stdout 2>stderr
	if ! diff -w -s stdout <(echo hello) &>/dev/null; then
	    echo '$@: stdout != hello';
	    cat stdout; $(FAIL);
	fi
	if ! diff -w -s stderr <(echo world) &>/dev/null; then
	    echo '$@: stderr != world';
	    $(FAIL)
	fi
	$(OK)


sum4and7is11:
	./run test/sum.py3 <test/4space7.txt >stdout 2>stderr
	if ! diff -sw stdout <(echo 11) &>/dev/null; then
	    echo '$@: stdout != 11';
	    $(FAIL);
	fi
	$(OK)
