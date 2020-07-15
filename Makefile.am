bin_PROGRAMS = rwtest
man_MANS = man/rwtest.8
TESTS = tests/init.sh tests/default_run.sh tests/invalid_run.sh tests/clean.sh

rwtest_SOURCES = src/rwtest.c include/rwtest.h

AM_CFLAGS   =
AM_CXXFLAGS =

rwtest_CFLAGS = -I$(top_srcdir)/include
if DEBUG
rwtest_CFLAGS += -DRWTEST_DEBUG -O0 -g3 -coverage -Wall
else
rwtest_CFLAGS += -O2
endif
