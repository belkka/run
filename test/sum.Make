#!/usr/bin/make -f
.PHONY: compile run clean

override src = test/sum.cpp
bin = ./prog

run: compile
	"$(bin)"

compile: $(bin)

clean:
	-rm "$(bin)"


WARNINGS = -Wall -Wfloat-equal -Wlogical-op -Wshift-overflow=2 \
           -Wduplicated-cond -Wconversion
CPPFLAGS = -std=gnu++17

$(bin): $(src)
	g++ -o "$(bin)" -D LOCAL -g $(CPPFLAGS) $(WARNINGS) "$(src)"
