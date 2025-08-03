#!/bin/bash

FILE_PATH="${1:-./include/i19c/}"
I19C_PATH="./.i19c"
I19C_HEADER_PATH="$I19C_PATH/i19cH.h"

rm -rf "$I19C_PATH"
mkdir -p "$I19C_PATH/cache"
touch "$I19C_HEADER_PATH"

cat<<EOF >> "$I19C_HEADER_PATH"
#ifndef I19C_HEADER_H
#define I19C_HEADER_H

#include <string.h>
#include <stdarg.h>
#include <stdlib.h>

EOF

for file in "$FILE_PATH"/*; do
	sed -E "s/#define ([A-Za-z_][A-Za-z0-9_]*) +\"/#define \1_$(basename "${file%.*}") \"/" \
		"$file" > "$I19C_PATH/cache/$(basename "$file")"
	echo "#include \"cache/$(basename "$file")\"" >> "$I19C_HEADER_PATH"
done

cat<<EOF >> "$I19C_HEADER_PATH"

typedef struct {
    char *path;
    char *language;
} I19C ;

static inline char *parse(const char *text, va_list arg) {
	size_t cap = 128;
	char *r_text = calloc(cap, 1);
	size_t len = 0;

	for (size_t i = 0; text[i]; i++) {
		if (text[i] == '\\\' && text[i+1] == '@') {
			if (len + 1 >= cap) {
				cap *= 2;
				r_text = realloc(r_text, cap);
			}
			r_text[len++] = '@';
			i++; continue;
		}
		if (text[i] == '@') {
			char *arg_s = va_arg(arg, char*);
			size_t alen = strlen(arg_s);
			if (len + alen >= cap) {
				cap = (len + alen + 1) * 2;
				r_text = realloc(r_text, cap);
			}
			strcpy(r_text + len, arg_s);
			len += alen;
			continue;
		}
		if (len + 1 >= cap) {
			cap *= 2;
			r_text = realloc(r_text, cap);
		}
		r_text[len++] = text[i];
	}

	r_text[len] = '\0';
	return r_text;
}

EOF

cat<<EOF >> "$I19C_HEADER_PATH"
static inline char *T(I19C *ctx, const char *text, ...) {
	va_list arg;
	va_start (arg, text);

EOF
for file in "$FILE_PATH"/*; do
    lang=$(basename "${file%.*}")
    echo "    if (strcmp(ctx->language, \"$lang\") == 0) {" >> "$I19C_HEADER_PATH"
    echo "        if (0) ;" >> "$I19C_HEADER_PATH"
	for text in $(grep '^#define' "$file" | sed -E 's/^#define[[:space:]]+([A-Z_]+).*/\1/' | tail -n +2); do
		echo "        else if (strcmp(text, \"$text\") == 0) return parse (${text}_$lang, arg);" >> "$I19C_HEADER_PATH"
	done
    echo "    }" >> "$I19C_HEADER_PATH"
done
echo -e "    return \"<missing>\";\n}" >> "$I19C_HEADER_PATH"

echo -e "\n#endif /* I19C_HEADER_H */" >> "$I19C_HEADER_PATH"
