CC = clang
CFLAGS = -Wall -O3 -Iinclude -I.i19c

BIN = bin
UTILS_HEADER = ./utils/headers.sh

SRC = src/i19c.c
OBJ = $(patsubst %.c, $(BIN)/%.o, $(SRC))

.PHONY: all dirs util clean build test run exec

all: clean util dirs build

clean:
	rm -rf $(BIN)

dirs:
	mkdir -p $(BIN)

util:
	chmod +x $(UTILS_HEADER)
	$(UTILS_HEADER) $(path)

build: $(OBJ)
	ar rcs $(BIN)/libi19c.a $^

$(BIN)/%.o: %.c 
	mkdir -p $(dir $@)
	$(CC) -o $@ -c $< $(CFLAGS)

test: clean dirs util
	$(CC) -o $(BIN)/i19c_test src/i19c.c src/i19c_testing.c $(CFLAGS)

run: test
	$(BIN)/i19c_test $(path)
