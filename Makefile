CFLAGS = -Wall -Werror -Wextra -framework Cocoa
CC = clang

compile:
	$(CC) bfcompiler.m $(CFLAGS)


