#!/bin/bash

FILE_PATH="./include/i19c/"
I19C_PATH="./.i19c" 
I19C_HEADER_PATH=$I19C_PATH/header.h 

rm -rf $I19C_PATH
mkdir -p $I19C_PATH
touch $I19C_HEADER_PATH 

echo -e "#ifndef I19C_HEADER_H\n#define I19C_HEADER_H\n" >> $I19C_HEADER_PATH 

for file in "$FILE_PATH"/*; do
	mkdir -p "$I19C_PATH/cache"
	sed -E "s/#define ([A-Za-z_][A-Za-z0-9_]*) +\"/#define \1_$(basename "${file%.*}" | tr "[a-z]" "[A-Z]") \"/" \
  		"$FILE_PATH$(basename "$file")" > "$I19C_PATH/cache/$(basename "$file")"
	echo "#include \"cache/$(basename "$file")\"" >> "$I19C_HEADER_PATH"
done

echo -e "\n#endif /* I19C_HEADER_H */" >> $I19C_HEADER_PATH 
