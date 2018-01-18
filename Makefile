#!/usr/bin/make -f
.PHONY: testing stdout_hello_stderr_world sum4and7is11
.SILENT:

SHELL = bash

GREEN_OK = "$$(tput setaf 2)OK$$(tput sgr0)"
OK = echo "$@: $(GREEN_OK)"
FAIL = echo "$@: $$(tput setaf 1)FAIL$$(tput sgr0)"; exit


testing: stdout_hello_stderr_world sum4and7is11
	[ -f stdout ] && rm stdout
	[ -f stderr ] && rm stderr


stdout_hello_stderr_world:
	./run test/stdout_hello_stderr_world.cpp --cleanup >stdout 2>stderr
	
	if ! diff -w -s stdout <(echo hello) &>/dev/null; then \
		echo ' * stdout != hello'; \
		$(FAIL); \
	fi
	
	if ! diff -w -s stderr <(echo world) &>/dev/null; then \
		echo ' * stderr != world'; \
		$(FAIL); \
	fi
	
	if [ -f ./prog ]; then \
		echo ' * ./prog is not cleaned up'; \
		$(FAIL); \
	fi
	$(OK)


sum4and7is11:
	for sum in test/sum.*; do \
		echo 4 7 | ./run "$$sum" --cleanup >stdout; \
		if ! diff -sw stdout <(echo 11) &>/dev/null; then \
			echo " * $${sum}: stdout != 11"; \
			$(FAIL); \
		else \
			echo " * $${sum}: $(GREEN_OK)"; \
		fi; \
	done
	$(OK)
