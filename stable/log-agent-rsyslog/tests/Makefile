#!/usr/bin/make -f

TESTSUITESDIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
TESTSUITES:=$(shell find $(TESTSUITESDIR) -name '*.bats')

.PHONY: test
test:
	bats --tap $(TESTSUITES)
