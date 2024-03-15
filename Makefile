CFLAGS = -Wall -Werror -Wextra -framework Cocoa
CC = clang

compile:
	$(CC) compiler.m $(CFLAGS)


