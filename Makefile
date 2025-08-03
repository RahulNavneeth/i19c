CC = clang
CFLAGS = -Wall -O3
CFLAGS := -Iinclude -I.i19c

BIN = bin
SRC = $(shell find . | grep "\.c")
OBJ = $(patsubst %.c, $(BIN)/%.o, $(SRC))
UTILS_HEADER = "./utils/headers.sh"

.PHONY: all dirs util clean build

all: clean util dirs build

clean:
	rm -rf $(BIN)

dirs:
	mkdir $(BIN)

util:
	chmod +x $(UTILS_HEADER)
	$(UTILS_HEADER) $(path)

build: $(OBJ)
	ar rcs $(BIN)/libi19c.a $^

exec: $(OBJ)
	$(CC) -o $(BIN)/i19c $^

$(BIN)/%.o: %.c 
	mkdir -p $(dir $@)
	$(CC) -o $@ -c $< $(CFLAGS)

run:
	$(BIN)/i19c $(path)
