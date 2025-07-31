#!/bin/bash

FILE_PATH="${1:-./include/i19c/}"
I19C_PATH="./.i19c"
I19C_HEADER_PATH="$I19C_PATH/i19cH.h"

rm -rf "$I19C_PATH"
mkdir -p "$I19C_PATH/cache"
touch "$I19C_HEADER_PATH"

echo -e "#ifndef I19C_HEADER_H\n#define I19C_HEADER_H\n\n#include <string.h>\n" >> "$I19C_HEADER_PATH"

for file in "$FILE_PATH"/*; do
	sed -E "s/#define ([A-Za-z_][A-Za-z0-9_]*) +\"/#define \1_$(basename "${file%.*}") \"/" \
		"$file" > "$I19C_PATH/cache/$(basename "$file")"
	echo "#include \"cache/$(basename "$file")\"" >> "$I19C_HEADER_PATH"
done

echo -e "\ntypedef struct {\n    char *path;\n    char *language;\n} I19C ;\n" >> "$I19C_HEADER_PATH"

echo -e "static inline char *T(I19C *ctx, const char *text) {" >> "$I19C_HEADER_PATH"
for file in "$FILE_PATH"/*; do
    lang=$(basename "${file%.*}")
    echo "    if (strcmp(ctx->language, \"$lang\") == 0) {" >> "$I19C_HEADER_PATH"
    echo "        if (0) ;" >> "$I19C_HEADER_PATH"
    for text in $(grep -oP '^#define\s+\K[A-Z_]+' "$file" | tail -n +2); do
        echo "        else if (strcmp(text, \"$text\") == 0) return ${text}_$lang;" >> "$I19C_HEADER_PATH"
    done
    echo "    }" >> "$I19C_HEADER_PATH"
done
echo -e "    return \"<missing>\";\n}" >> "$I19C_HEADER_PATH"

echo -e "\n#endif /* I19C_HEADER_H */" >> "$I19C_HEADER_PATH"
