#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "i19c.h"

I19C *get_i19c() {
    static I19C singleton;
    static int initialized = 0;
    if (!initialized) {
        singleton.language = strdup("en");
        singleton.path = strdup(".i19c");
        initialized = 1;
    }
    return &singleton;
}

void set_path_i19c(I19C *ctx, const char *path) {
	if (ctx->path) free(ctx->path);
	ctx->path = strdup(path); 
}

void set_lang_i19c(I19C *ctx, const char *lang) {
	if (ctx->language) free(ctx->language);
	ctx->language = strdup(lang);
}
